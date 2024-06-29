import SwiftUI

struct EntryInputView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var food: String = ""
    @State private var symptoms: String = ""
    @State private var showSaveIndicator = false
    
    var body: some View {
        VStack {
            TextField("Enter food", text: $food)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter symptoms", text: $symptoms)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: saveEntry) {
                Text("Save Entry")
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
        .navigationBarTitle("New Entry", displayMode: .inline)
    }
    
    private func saveEntry() {
        let newEntry = FoodEntry(context: viewContext)
        newEntry.food = food
        newEntry.symptoms = symptoms
        newEntry.date = Date()
        
        do {
            try viewContext.save()
            showSaveIndicator = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSaveIndicator = false
            }
            food = ""
            symptoms = ""
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
