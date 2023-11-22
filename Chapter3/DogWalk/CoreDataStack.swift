import CoreData
import Foundation

class CoreDataStack {
  private let modelName: String

  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        debugPrint("Unresolved error \(error), \(error.userInfo)")
      }
    }

    return container
  }()

  lazy var managedContext: NSManagedObjectContext = storeContainer.viewContext

  init(modelName: String) {
    self.modelName = modelName
  }

  func saveContext() {
    guard managedContext.hasChanges else {
      return
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      debugPrint("Unresolved error \(error), \(error.userInfo)")
    }
  }
}
