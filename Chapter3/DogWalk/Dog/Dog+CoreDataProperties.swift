import CoreData
import Foundation

public extension Dog {
  @nonobjc class func fetchRequest() -> NSFetchRequest<Dog> {
    return NSFetchRequest<Dog>(entityName: "Dog")
  }

  @NSManaged var name: String?
  @NSManaged var walks: NSOrderedSet?
}

// MARK: Generated accessors for walks

public extension Dog {
  @objc(insertObject:inWalksAtIndex:)
  @NSManaged func insertIntoWalks(_ value: Walk, at idx: Int)

  @objc(removeObjectFromWalksAtIndex:)
  @NSManaged func removeFromWalks(at idx: Int)

  @objc(insertWalks:atIndexes:)
  @NSManaged func insertIntoWalks(_ values: [Walk], at indexes: NSIndexSet)

  @objc(removeWalksAtIndexes:)
  @NSManaged func removeFromWalks(at indexes: NSIndexSet)

  @objc(replaceObjectInWalksAtIndex:withObject:)
  @NSManaged func replaceWalks(at idx: Int, with value: Walk)

  @objc(replaceWalksAtIndexes:withWalks:)
  @NSManaged func replaceWalks(at indexes: NSIndexSet, with values: [Walk])

  @objc(addWalksObject:)
  @NSManaged func addToWalks(_ value: Walk)

  @objc(removeWalksObject:)
  @NSManaged func removeFromWalks(_ value: Walk)

  @objc(addWalks:)
  @NSManaged func addToWalks(_ values: NSOrderedSet)

  @objc(removeWalks:)
  @NSManaged func removeFromWalks(_ values: NSOrderedSet)
}

extension Dog: Identifiable {}
