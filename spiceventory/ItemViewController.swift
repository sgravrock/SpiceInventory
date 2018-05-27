import UIKit

class ItemViewController: UITableViewController {
    private var _dataSource: UITableViewDataSource? = nil
    
    var dataSource: UITableViewDataSource? {
        get {
            return _dataSource
        }
        
        set {
            _dataSource = newValue
            tableView.dataSource = newValue
        }
    }
}
