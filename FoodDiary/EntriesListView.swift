import SwiftUI
import CoreData

struct EntriesListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<FoodEntry>
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        List {
            ForEach(entries) { entry in
                VStack(alignment: .leading) {
                    Text("Date: \(entry.date ?? Date(), formatter: dateFormatter)")
                    Text("Time: \(entry.time ?? Date(), formatter: timeFormatter)")
                    Text("Food: \(entry.food ?? "")")
                    Text("Symptoms: \(entry.symptoms ?? "")")
                    NavigationLink(destination: EntryInputView(entry: entry)) {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onDelete(perform: deleteEntries)
        }
        .navigationBarTitle("Food Diary Entries")
        .navigationBarItems(trailing: EditButton())
    }

    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            offsets.map { entries[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Failed to delete entry: \(error.localizedDescription)")
            }
        }
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
