import SwiftUI
import CoreData

struct ViewChartsView: View {
    @FetchRequest(
        entity: FoodEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: true)]
    ) var entries: FetchedResults<FoodEntry>
    
    var body: some View {
        VStack {
            Text("Data Analysis")
                .font(.largeTitle)
                .padding()
            
            if entries.isEmpty {
                Text("No data available.")
                    .font(.title)
                    .padding()
            } else {
                // Add your charts here
                // Example: BarChart(entries: entries)
                Text("Charts will be here")
            }
        }
        .navigationBarTitle("Charts", displayMode: .inline)
    }
}

struct ViewChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewChartsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
