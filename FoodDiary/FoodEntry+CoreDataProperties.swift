import Foundation
import CoreData

extension FoodEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntry> {
        return NSFetchRequest<FoodEntry>(entityName: "FoodEntry")
    }

    @NSManaged public var date: Date?
    @NSManaged public var time: Date?
    @NSManaged public var food: String?
    @NSManaged public var symptoms: String?
}

extension FoodEntry: Identifiable {

}
