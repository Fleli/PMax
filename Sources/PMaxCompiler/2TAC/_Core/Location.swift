enum Location: CustomStringConvertible {
    
    case framePointer(offset: Int)
    case textSegment(index: Int)
    
    var description: String {
        switch self {
        case .framePointer(let offset):
            return "[fp + \(offset)]"
        case .textSegment(let index):
            return "[text @ \(index)]"
        }
    }
    
}
