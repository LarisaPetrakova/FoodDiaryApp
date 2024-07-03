import SwiftUI

struct EntryInputView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var food: String = ""
    @State private var symptoms: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var showSaveIndicator = false

    var entry: FoodEntry?

    var body: some View {
        VStack {
            TextField("Enter food", text: $food)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter symptoms", text: $symptoms)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            DatePicker("Select date", selection: $date, displayedComponents: .date)
                .padding()
            
            DatePicker("Select time", selection: $time, displayedComponents: .hourAndMinute)
                .padding()
            
            Button(action: saveEntry) {
                Text(entry == nil ? "Save Entry" : "Update Entry")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            if showSaveIndicator {
                Text("Entry saved!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .navigationBarTitle(entry == nil ? "New Entry" : "Edit Entry", displayMode: .inline)
        .onAppear {
            if let entry = entry {
                food = entry.food ?? ""
                symptoms = entry.symptoms ?? ""
                date = entry.date ?? Date()
                time = entry.time ?? Date()
            }
        }
    }
    
    private func saveEntry() {
        let entryToSave = entry ?? FoodEntry(context: viewContext)
        entryToSave.food = food
        entryToSave.symptoms = symptoms
        entryToSave.date = date
        entryToSave.time = time
        
        do {
            try viewContext.save()
            showSaveIndicator = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSaveIndicator = false
            }
            if entry == nil {
                food = ""
                symptoms = ""
            }
        } catch {
            print("Failed to save entry: \(error.localizedDescription)")
        }
    }
}

struct EntryInputView_Previews: PreviewProvider {
    static var previews: some View {
        EntryInputView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
