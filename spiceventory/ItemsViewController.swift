import UIKit

class ItemsViewController: UITableViewController {
    private var _dataSource: ItemsDataSource? = nil
    
    var dataSource: ItemsDataSource? {
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
    
    @IBAction func showAddDialog(_ sender: Any) {
        let alert = UIAlertController(title: "Add Spice",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField()
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let name = alert.textFields!.first!.text!
            self.dataSource?.add(name: name)
            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}
