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

class ViewController: UIViewController {
  // MARK: - Properties

  private let teamCellIdentifier = "teamCellReuseIdentifier"
  lazy var coreDataStack = CoreDataStack(modelName: "WorldCup")

  lazy var fetchedResultsController: NSFetchedResultsController<Team> = {
    let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()

    let zoneSort = NSSortDescriptor(
      key: #keyPath(Team.qualifyingZone),
      ascending: true
    )

    let scoreSort = NSSortDescriptor(
      key: #keyPath(Team.wins),
      ascending: false
    )

    let nameSort = NSSortDescriptor(
      key: #keyPath(Team.teamName),
      ascending: true
    )

    fetchRequest.sortDescriptors = [zoneSort, scoreSort, nameSort]

    let fetchResultController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.managedContext,
      sectionNameKeyPath: #keyPath(Team.qualifyingZone),
      cacheName: nil
    )

    return fetchResultController
  }()

  // MARK: - IBOutlets

  @IBOutlet var tableView: UITableView!
  @IBOutlet var addButton: UIBarButtonItem!

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    importJSONSeedDataIfNeeded()

    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      debugPrint("Fetching error: \(error), \(error.userInfo)")
    }
  }
}

// MARK: - Internal

extension ViewController {
  func configure(
    cell: UITableViewCell,
    for indexPath: IndexPath
  ) {
    guard let cell = cell as? TeamCell else {
      return
    }

    let team = fetchedResultsController.object(at: indexPath)
    cell.teamLabel.text = team.teamName
    cell.scoreLabel.text = "Wins: \(team.wins)"

    if let imageName = team.imageName {
      cell.flagImageView.image = UIImage(named: imageName)
    } else {
      cell.flagImageView.image = nil
    }
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    fetchedResultsController.sections?.count ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    guard let sectionsInfo = fetchedResultsController.sections?[section] else {
      return 0
    }

    return sectionsInfo.numberOfObjects
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: teamCellIdentifier,
      for: indexPath
    )
    configure(cell: cell, for: indexPath)

    return cell
  }

  func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    let sectionInfo = fetchedResultsController.sections?[section]
    return sectionInfo?.name
  }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let team = fetchedResultsController.object(at: indexPath)
    team.wins += 1
    coreDataStack.saveContext()
    tableView.reloadData()
  }
}

// MARK: - Helper methods

extension ViewController {
  func importJSONSeedDataIfNeeded() {
    let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
    let count = try? coreDataStack.managedContext.count(for: fetchRequest)

    guard let teamCount = count,
          teamCount == 0
    else {
      return
    }

    importJSONSeedData()
  }

  func importJSONSeedData() {
    let jsonURL = Bundle.main.url(
      forResource: "seed",
      withExtension: "json"
    )!

    let jsonData = try! Data(contentsOf: jsonURL)

    do {
      let jsonArray = try JSONSerialization.jsonObject(
        with: jsonData,
        options: [.allowFragments]
      ) as! [[String: Any]]

      for jsonDictionary in jsonArray {
        let teamName = jsonDictionary["teamName"] as! String
        let zone = jsonDictionary["qualifyingZone"] as! String
        let imageName = jsonDictionary["imageName"] as! String
        let wins = jsonDictionary["wins"] as! NSNumber

        let team = Team(context: coreDataStack.managedContext)
        team.teamName = teamName
        team.imageName = imageName
        team.qualifyingZone = zone
        team.wins = wins.int32Value
      }

      coreDataStack.saveContext()
      print("Imported \(jsonArray.count) teams")
    } catch let error as NSError {
      print("Error importing teams: \(error)")
    }
  }
}
