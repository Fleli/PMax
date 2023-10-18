enum Location: CustomStringConvertible {
    
    case framePointer(offset: Int)
    case dataSection(index: Int)
    
    var description: String {
        switch self {
        case .framePointer(let offset):
            return "[fp + \(offset)]"
        case .dataSection(let index):
            return "[text @ \(index)]"
        }
    }
    
}
