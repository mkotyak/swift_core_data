import CoreData
import Foundation
import UIKit

public extension BowTie {
  @nonobjc class func fetchRequest() -> NSFetchRequest<BowTie> {
    NSFetchRequest<BowTie>(entityName: "BowTie")
  }

  @NSManaged var name: String?
  @NSManaged var isFavorite: Bool
  @NSManaged var lastWorn: Date?
  @NSManaged var rating: Double
  @NSManaged var searchKey: String?
  @NSManaged var timesWorn: Int32
  @NSManaged var url: URL?
  @NSManaged var id: UUID?
  @NSManaged var photoData: Data?
  @NSManaged var tintColor: UIColor?
}

extension BowTie: Identifiable {}
