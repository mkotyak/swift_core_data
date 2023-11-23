import Foundation

protocol FilterViewControllerDelegate: AnyObject {
  func filterViewController(
    filter: FilterViewController,
    didSelectPredicate predicate: NSPredicate?,
    sortDescription: NSSortDescriptor?
  )
}
