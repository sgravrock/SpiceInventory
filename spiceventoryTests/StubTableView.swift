import UIKit

class StubTableView: UITableView {

    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        return ItemCell(coder: NSKeyedUnarchiver(forReadingWith: Data()))
    }

}
