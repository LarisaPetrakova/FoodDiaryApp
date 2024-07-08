import SwiftUI
import CoreData

struct EntryInputView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var food: String = ""
    @State private var symptoms: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var showSaveIndicator = false
    @State private var foodSuggestions: [String] = []
    @State private var symptomSuggestions: [String] = []
    
    var entry: FoodEntry?

    var body: some View {
        VStack {
            TextField("Enter food", text: $food, onEditingChanged: { isEditing in
                if isEditing {
                    fetchFoodSuggestions()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: food) { _ in
                fetchFoodSuggestions()
            }

            if !foodSuggestions.isEmpty {
                List(foodSuggestions, id: \.self) { suggestion in
                    Text(suggestion)
                        .onTapGesture {
                            food = suggestion
                            foodSuggestions = []
                        }
                }
                .frame(height: 100)
            }

            TextField("Enter symptoms", text: $symptoms, onEditingChanged: { isEditing in
                if isEditing {
                    fetchSymptomSuggestions()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: symptoms) { _ in
                fetchSymptomSuggestions()
            }

            if !symptomSuggestions.isEmpty {
                List(symptomSuggestions, id: \.self) { suggestion in
                    Text(suggestion)
                        .onTapGesture {
                            symptoms = suggestion
                            symptomSuggestions = []
                        }
                }
                .frame(height: 100)
            }
            
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
    
    private func fetchFoodSuggestions() {
        let request: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        request.predicate = NSPredicate(format: "food CONTAINS[cd] %@", food)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodEntry.food, ascending: true)]
        request.returnsDistinctResults = true

        do {
            let results = try viewContext.fetch(request)
            foodSuggestions = Array(Set(results.compactMap { $0.food })).sorted()
        } catch {
            print("Failed to fetch food suggestions: \(error.localizedDescription)")
        }
    }

    private func fetchSymptomSuggestions() {
        let request: NSFetchRequest<FoodEntry> = FoodEntry.fetchRequest()
        request.predicate = NSPredicate(format: "symptoms CONTAINS[cd] %@", symptoms)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodEntry.symptoms, ascending: true)]
        request.returnsDistinctResults = true

        do {
            let results = try viewContext.fetch(request)
            symptomSuggestions = Array(Set(results.compactMap { $0.symptoms })).sorted()
        } catch {
            print("Failed to fetch symptom suggestions: \(error.localizedDescription)")
        }
    }
}

struct EntryInputView_Previews: PreviewProvider {
    static var previews: some View {
        EntryInputView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
