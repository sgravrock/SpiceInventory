import UIKit
import CoreData

class ItemsDataSource: NSObject, UITableViewDataSource, ItemCellDelegate {
    
    private let persistentContainer: NSPersistentContainer
    private var items: [Item] = []
    private static var amountLabels = (0...Amount.maxValue).map { (i: Int32) -> String in
        return Amount(rawValue: i)!.description
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func fetch() {
        do {
            self.items = try persistentContainer.viewContext.fetch(
                NSFetchRequest(entityName: "Item")
            ) as! [Item]
        } catch let error as NSError {
            // TODO: How to handle this?
            print("Error fetching data: \(error)")
        }
    }
    
    func add(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Item",
                                       in: persistentContainer.viewContext)!
        let item = Item(entity: entity, insertInto: persistentContainer.viewContext)
        item.name = name
        
        do {
            try persistentContainer.viewContext.save()
            items.append(item)
        } catch let error as NSError {
            // TODO: How to handle this?
            print("Error fetching data: \(error)")
        }
    }
    
    func delete(itemAt index: Int) {
        persistentContainer.viewContext.delete(items[index])
        items.remove(at: index)
        save()
    }
    
    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            // TODO: How to handle this?
            print("Error fetching data: \(error)")
        }
    }
    
    // MARK: - ItemCellDelegate methods

    func cellForItem(_ item: Item, didChangeAmount amount: Amount) {
        item.amount = amount
        save()
    }

    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal cell") as! ItemCell
        cell.item = items[indexPath.row]
        cell.delegate = self
        return cell
    }

}
