/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreData
import UIKit

protocol FilterViewControllerDelegate: AnyObject {
  func filterViewController(
    filter: FilterViewController,
    didSelectPredicate predicate: NSPredicate?,
    sortDescription: NSSortDescriptor?
  )
}

class FilterViewController: UITableViewController {
  @IBOutlet var firstPriceCategoryLabel: UILabel!
  @IBOutlet var secondPriceCategoryLabel: UILabel!
  @IBOutlet var thirdPriceCategoryLabel: UILabel!
  @IBOutlet var numDealsLabel: UILabel!

  // MARK: - Price section

  @IBOutlet var cheapVenueCell: UITableViewCell!
  @IBOutlet var moderateVenueCell: UITableViewCell!
  @IBOutlet var expensiveVenueCell: UITableViewCell!

  // MARK: - Most popular section

  @IBOutlet var offeringDealCell: UITableViewCell!
  @IBOutlet var walkingDistanceCell: UITableViewCell!
  @IBOutlet var userTipsCell: UITableViewCell!

  // MARK: - Sort section

  @IBOutlet var nameAZSortCell: UITableViewCell!
  @IBOutlet var nameZASortCell: UITableViewCell!
  @IBOutlet var distanceSortCell: UITableViewCell!
  @IBOutlet var priceSortCell: UITableViewCell!

  // MARK: - Properties

  var coreDataStack: CoreDataStack!

  weak var delegate: FilterViewControllerDelegate?
  var selectedSortDescriptor: NSSortDescriptor?
  var selectedPredicate: NSPredicate?

  lazy var cheapVenuePredicate: NSPredicate = .init(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$")
  lazy var moderateVenuePredicate: NSPredicate = .init(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$")
  lazy var expenciveVenuePredicate: NSPredicate = .init(format: "%K == %@", #keyPath(Venue.priceInfo.priceCategory), "$$$")

  lazy var offeringDealPredicate: NSPredicate = .init(format: "%K > 0", #keyPath(Venue.specialCount))
  lazy var walkingDistancePredicate: NSPredicate = .init(format: "%K < 0", #keyPath(Venue.location.distance))
  lazy var hasUserTipsPredicate: NSPredicate = .init(format: "%K > 0", #keyPath(Venue.stats.tipCount))

  lazy var nameSortDescriptor: NSSortDescriptor = {
    let compareSelector = #selector(NSString.localizedStandardCompare(_:))

    return NSSortDescriptor(
      key: #keyPath(Venue.name),
      ascending: true,
      selector: compareSelector
    )
  }()

  lazy var distanceSortDescriptor: NSSortDescriptor = .init(key: #keyPath(Venue.location.distance), ascending: true)
  lazy var priceSortDescriptor: NSSortDescriptor = .init(key: #keyPath(Venue.priceInfo.priceCategory), ascending: true)

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    populateCheapVenueCountLabel()
    populateModerateVenueCountLabel()
    populateExpenciveVenueCountLabel()
    populateDealCountLabel()
  }
}

// MARK: - IBActions

extension FilterViewController {
  @IBAction func search(_ sender: UIBarButtonItem) {
    delegate?.filterViewController(
      filter: self,
      didSelectPredicate: selectedPredicate,
      sortDescription: selectedSortDescriptor
    )

    dismiss(animated: true)
  }
}

// MARK: - UITableViewDelegate

extension FilterViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }

    switch cell {
    // Price section
    case cheapVenueCell:
      selectedPredicate = cheapVenuePredicate
    case moderateVenueCell:
      selectedPredicate = moderateVenuePredicate
    case expensiveVenueCell:
      selectedPredicate = expenciveVenuePredicate

    // Most Popular section
    case offeringDealCell:
      selectedPredicate = offeringDealPredicate
    case walkingDistanceCell:
      selectedPredicate = walkingDistancePredicate
    case userTipsCell:
      selectedPredicate = hasUserTipsPredicate

    // Sort By section
    case nameAZSortCell:
      selectedSortDescriptor = nameSortDescriptor
    case nameZASortCell:
      selectedSortDescriptor = nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor
    case distanceSortCell:
      selectedSortDescriptor = distanceSortDescriptor
    case priceSortCell:
      selectedSortDescriptor = priceSortDescriptor
    default:
      break
    }

    cell.accessoryType = .checkmark
  }
}

// MARK: - Helper method

extension FilterViewController {
  func populateCheapVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = cheapVenuePredicate

    do {
      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)

      let count = countResult.first?.intValue ?? 0
      let pluralized = count == 1 ? "place" : "places"

      firstPriceCategoryLabel.text = "\(count) bubble rea \(pluralized)"
    } catch let error as NSError {
      debugPrint("Could not fetch \(error), \(error.userInfo)")
    }
  }

  func populateModerateVenueCountLabel() {
    let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Venue")
    fetchRequest.resultType = .countResultType
    fetchRequest.predicate = moderateVenuePredicate

    do {
      let countResult = try coreDataStack.managedContext.fetch(fetchRequest)

      let count = countResult.first?.intValue ?? 0
      let pluralized = count == 1 ? "place" : "places"

      secondPriceCategoryLabel.text = "\(count) bubble rea \(pluralized)"
    } catch let error as NSError {
      debugPrint("Could not fetch \(error), \(error.userInfo)")
    }
  }

  func populateExpenciveVenueCountLabel() {
    let fetchRequest: NSFetchRequest<Venue> = Venue.fetchRequest()
    fetchRequest.predicate = expenciveVenuePredicate

    do {
      let count = try coreDataStack.managedContext.count(for: fetchRequest)
      let pluralized = count == 1 ? "place" : "places"

      thirdPriceCategoryLabel.text = "\(count) bubble rea \(pluralized)"
    } catch let error as NSError {
      debugPrint("Could not fetch \(error), \(error.userInfo)")
    }
  }

  func populateDealCountLabel() {
    // 1
    let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Venue")
    fetchRequest.resultType = .dictionaryResultType

    // 2
    let sumExpressionDesc = NSExpressionDescription()
    sumExpressionDesc.name = "sumDeals"

    // 3
    let specialCountExp = NSExpression(forKeyPath: #keyPath(Venue.specialCount))

    sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [specialCountExp])
    sumExpressionDesc.expressionResultType = .integer32AttributeType

    // 4
    fetchRequest.propertiesToFetch = [sumExpressionDesc]

    // 5
    do {
      let results = try coreDataStack.managedContext.fetch(fetchRequest)

      let resultDict = results.first
      let numDeals = resultDict?["sumDeals"] as? Int ?? 0

      let pluralized = numDeals == 1 ? "deal" : "deals"
      numDealsLabel.text = "\(numDeals) \(pluralized)"
    } catch let error as NSError {
      debugPrint("Could not fetch \(error), \(error.userInfo)")
    }
  }
}
