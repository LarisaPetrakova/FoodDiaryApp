import SwiftUI
import Charts
import CoreData

struct ChartView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<FoodEntry>
    
    @State private var data: [FoodSymptomData] = []
    
    var body: some View {
        VStack {
            Text("Data Visualization")
                .font(.largeTitle)
                .padding()
            
            if data.isEmpty {
                Text("No data available")
            } else {
                Chart(data) {
                    BarMark(
                        x: .value("Food", $0.food),
                        y: .value("Occurrences", $0.occurrences)
                    )
                    .foregroundStyle(by: .value("Symptom", $0.symptom))
                }
                .chartForegroundStyleScale([
                    "Symptom1": .blue,
                    "Symptom2": .red,
                    "Symptom3": .green,
                    // Add other symptoms as needed
                ])
                .frame(height: 300)
                
                Text("Heatmap")
                    .font(.title2)
                
                Heatmap(data: data)
                    .frame(height: 300)
            }
        }
        .onAppear(perform: prepareData)
        .navigationBarTitle("Charts", displayMode: .inline)
    }
    
    private func prepareData() {
        var foodSymptomDict: [String: [String]] = [:]
        
        for entry in entries {
            guard let food = entry.food, let symptoms = entry.symptoms else { continue }
            let foodItems = food.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            let symptomItems = symptoms.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            
            for foodItem in foodItems {
                if foodSymptomDict[foodItem] == nil {
                    foodSymptomDict[foodItem] = []
                }
                foodSymptomDict[foodItem]?.append(contentsOf: symptomItems)
            }
        }
        
        var result: [FoodSymptomData] = []
        
        for (food, symptoms) in foodSymptomDict {
            let symptomCounts = symptoms.reduce(into: [:]) { counts, symptom in
                counts[symptom, default: 0] += 1
            }
            for (symptom, count) in symptomCounts {
                result.append(FoodSymptomData(food: food, symptom: symptom, occurrences: count))
            }
        }
        
        data = result
    }
}

struct FoodSymptomData: Identifiable {
    let id = UUID()
    let food: String
    let symptom: String
    let occurrences: Int
}

struct Heatmap: View {
    let data: [FoodSymptomData]
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = CGFloat(data.count).squareRoot().rounded(.up)
            let itemSize = geometry.size.width / gridSize
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: Int(gridSize))) {
                ForEach(data) { item in
                    Rectangle()
                        .fill(color(for: item.occurrences))
                        .frame(width: itemSize, height: itemSize)
                        .overlay(Text(item.symptom)
                            .foregroundColor(.white)
                            .font(.footnote))
                }
            }
        }
    }
    
    private func color(for occurrences: Int) -> Color {
        switch occurrences {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        default: return .red
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
