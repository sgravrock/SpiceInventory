import CoreData

enum Amount: Int32 {
    case Out = 0
    case Low = 1
    case Plenty = 2
    
    var description: String {
        switch self {
        case .Out: return "Out"
        case .Low: return "Low"
        case .Plenty: return "Plenty"
        }
    }
    
    static let maxValue: Int32 = Amount.Plenty.rawValue
}

class Item: NSManagedObject {
    @NSManaged var name: String
    @NSManaged private var amountValue: Int32
    
    var amount: Amount {
        get { return Amount(rawValue: amountValue)! }
        set { amountValue = newValue.rawValue }
    }
}
