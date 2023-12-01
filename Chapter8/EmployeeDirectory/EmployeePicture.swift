import CoreData
import Foundation

public class EmployeePicture: NSManagedObject {}

public extension EmployeePicture {
  @nonobjc
  class func fetchRequest() -> NSFetchRequest<EmployeePicture> {
    NSFetchRequest<EmployeePicture>(
      entityName: "EmployeePicture"
    )
  }

  @NSManaged var picture: Data?
  @NSManaged var employee: Employee?
}
