import UIKit
import CoreData

class ItemsDataSource: NSObject, UITableViewDataSource {
    
    private let persistentContainer: NSPersistentContainer
    private var items: [Item] = []
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal cell")!
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }

}
