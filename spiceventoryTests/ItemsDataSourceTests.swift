import XCTest
import CoreData

class ItemsDataSourceTests: XCTestCase {
    
    var container: NSPersistentContainer! = nil
    var subject: ItemsDataSource! = nil
    
    override func setUp() {
        super.setUp()
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container = NSPersistentContainer(name: "spiceventory", managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            precondition(error == nil)
        }

        subject = ItemsDataSource(persistentContainer: container)
    }
    
    func addItem(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Item",
                                                in: container.viewContext)!
        let item = Item(entity: entity, insertInto: container.viewContext)
        item.name = name
    }
    
    func testProvidesItems() {
        addItem(name: "foo")
        addItem(name: "bar")
        subject.fetch()
        let view = StubTableView()
        XCTAssertEqual(subject.tableView(view, numberOfRowsInSection: 0), 2);
        let names = (0..<2).map { (i: Int) -> String in
            let cell = subject.tableView(view, cellForRowAt: IndexPath(row: i, section: 0))
            return cell.textLabel!.text!
        }.sorted()
        XCTAssertEqual(names, ["bar", "foo"])
    }
    
    func testSavesItems() {
        subject.add(name: "a new item")
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let results = try! container.viewContext.fetch(request) as! [Item]
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].name, "a new item")
        XCTAssertEqual(results[0].amount, Amount.Plenty)
    }

}
