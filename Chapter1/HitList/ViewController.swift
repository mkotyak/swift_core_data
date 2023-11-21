import CoreData
import UIKit

class ViewController: UIViewController {
    private var people: [NSManagedObject] = []

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The list"
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")

        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(
            forEntityName: "Person",
            in: managedContext
        )!

        let person = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        )

        person.setValue(name, forKey: "name")

        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            debugPrint("Chould not save. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Actions

extension ViewController {
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New Name",
            message: "Add a new name",
            preferredStyle: .alert
        )

        let saveAction = UIAlertAction(
            title: "Save",
            style: .default
        ) { [weak self] _ in

            guard let self,
                  let textField = alert.textFields?.first,
                  let nameToSave = textField.text
            else {
                return
            }

            save(name: nameToSave)
            tableView.reloadData()
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )

        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}

// MARK: - UITableView

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        people.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )

        cell.textLabel?.text = person.value(forKeyPath: "name") as? String

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
