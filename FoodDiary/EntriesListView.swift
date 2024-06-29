import SwiftUI
import CoreData

struct EntriesListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<FoodEntry>
    
    var body: some View {
        List {
            ForEach(entries) { entry in
                VStack(alignment: .leading) {
                    Text("Date: \(entry.date ?? Date(), formatter: dateFormatter)")
                    Text("Time: \(entry.time ?? Date(), formatter: timeFormatter)")
                    Text("Food: \(entry.food ?? "")")
                    Text("Symptoms: \(entry.symptoms ?? "")")
                }
            }
        }
        .navigationBarTitle("Food Diary Entries")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct EntriesListView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
