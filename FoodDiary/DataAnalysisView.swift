import SwiftUI
import CoreData

struct DataAnalysisView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<FoodEntry>
    
    @State private var analysisResults: [String: [String]] = [:]
    
    var body: some View {
        VStack {
            Text("Data Analysis")
                .font(.largeTitle)
                .padding()
            
            if analysisResults.isEmpty {
                Text("No analysis available")
            } else {
                List {
                    ForEach(analysisResults.keys.sorted(), id: \.self) { food in
                        Section(header: Text(food)) {
                            ForEach(analysisResults[food]!, id: \.self) { symptom in
                                Text(symptom)
                            }
                        }
                    }
                }
            }
            
            NavigationLink(destination: ChartView()) {
                Text("View Charts")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: performDataAnalysis)
        .navigationBarTitle("Data Analysis", displayMode: .inline)
    }
    
    private func performDataAnalysis() {
        var foodToSymptoms: [String: [String]] = [:]
        
        for entry in entries {
            guard let food = entry.food, let symptoms = entry.symptoms else { continue }
            let foodItems = food.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            let symptomItems = symptoms.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            
            for foodItem in foodItems {
                if foodToSymptoms[foodItem] == nil {
                    foodToSymptoms[foodItem] = []
                }
                foodToSymptoms[foodItem]?.append(contentsOf: symptomItems)
            }
        }
        
        for (food, symptoms) in foodToSymptoms {
            foodToSymptoms[food] = Array(Set(symptoms))
        }
        
        analysisResults = foodToSymptoms
    }
}

struct DataAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        DataAnalysisView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
