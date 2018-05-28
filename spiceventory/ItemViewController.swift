import UIKit

class ItemViewController: UITableViewController {
    private var _dataSource: ItemDataSource? = nil
    
    var dataSource: ItemDataSource? {
        get {
            return _dataSource
        }
        
        set {
            _dataSource = newValue
            tableView.dataSource = newValue
        }
    }
    
    override func viewDidLoad() {
        _dataSource!.fetch()
    }
}
