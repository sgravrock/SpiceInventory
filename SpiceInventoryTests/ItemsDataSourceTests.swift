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
        
        container = NSPersistentContainer(name: "SpiceInventory", managedObjectModel: managedObjectModel)
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
    
    func namesInTable() -> [String] {
        let view = StubTableView()
        let n = subject.tableView(view, numberOfRowsInSection: 0)
        return (0..<n).map { (i: Int) -> String in
            let cell = subject.tableView(view, cellForRowAt: IndexPath(row: i, section: 0))
            return cell.textLabel!.text!
        }
    }
    
    func testProvidesItemsInAlphaOrder() {
        addItem(name: "foo")
        addItem(name: "bar")
        subject.fetch()
        XCTAssertEqual(namesInTable(), ["bar", "foo"])
    }

    func testSavesItems() {
        subject.add(name: "a new item")
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let results = try! container.viewContext.fetch(request) as! [Item]
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].name, "a new item")
        XCTAssertEqual(results[0].amount, Amount.Plenty)
    }

    func testAddsItemsInAlphaOrder() {
        addItem(name: "b")
        subject.fetch()
        subject.add(name: "c")
        subject.add(name: "a")
        XCTAssertEqual(namesInTable(), ["a", "b", "c"])
    }
    
}
