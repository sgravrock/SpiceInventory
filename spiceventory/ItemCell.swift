import UIKit

protocol ItemCellDelegate: NSObjectProtocol {
    func cellForItem(_ item: Item, didChangeAmount amount: Amount)
}

class ItemCell: UITableViewCell {
    private static var amountLabels = (0...Amount.maxValue).map { (i: Int32) -> String in
        return Amount(rawValue: i)!.description
    }
    
    weak var delegate: ItemCellDelegate?
    private let amountView: UISegmentedControl
    
    var item: Item? = nil {
        didSet {
            guard let item = item else { return }
            textLabel?.text = item.name
            amountView.selectedSegmentIndex = Int(item.amount.rawValue)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        amountView = UISegmentedControl(items: ItemCell.amountLabels)
        
        super.init(coder: aDecoder)
        
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.numberOfLines = 0
        accessoryView = amountView
        amountView.addTarget(self, action: #selector(ItemCell.amountChanged), for: .valueChanged)
    }
    
    @objc private func amountChanged(_ sender: UISegmentedControl) {
        let amount = Amount(rawValue: Int32(sender.selectedSegmentIndex))!
        delegate?.cellForItem(item!, didChangeAmount: amount)
    }
}
