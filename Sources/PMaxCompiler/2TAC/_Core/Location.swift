indirect enum Location: CustomStringConvertible {
    
    case framePointer(offset: Int)
    case dataSection(index: Int)
    
    /// A `.rawPointer(offset:)` represents a pointer. Raw pointers never store the actual address they point to. Instead, they refer to a variable on the stack (at a certain `offset`) that stores the address they point to.
    case rawPointer(offset: Int)
    
    var description: String {
        switch self {
        case .framePointer(let offset):
            return "[fp + \(offset)]"
        case .dataSection(let index):
            return "[text @ \(index)]"
        case .rawPointer(let offset):
            return "[raw @ fp + \(offset)]"
        }
    }
    
}
