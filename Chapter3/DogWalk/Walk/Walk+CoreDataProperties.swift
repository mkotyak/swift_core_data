import CoreData
import Foundation

public extension Walk {
  @nonobjc class func fetchRequest() -> NSFetchRequest<Walk> {
    return NSFetchRequest<Walk>(entityName: "Walk")
  }

  @NSManaged var date: Date?
  @NSManaged var dog: Dog?
}

extension Walk: Identifiable {}
