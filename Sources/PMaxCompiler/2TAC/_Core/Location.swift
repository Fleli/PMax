indirect enum Location: CustomStringConvertible {
    
    case framePointer(offset: Int)
    
    /// A `.literalValue` case does not really represent a memory location, but rather the direct use of a literal integer. This is (for example) used to offset in member references or to add literals to values.
    case literalValue(value: Int)
    
    /// A `.rawPointer(offset:)` represents a pointer. Raw pointers never store the actual address they point to. Instead, they refer to a variable on the stack (at a certain `offset`) that stores the address they point to.
    case rawPointer(offset: Int)
    
    var description: String {
        switch self {
        case .framePointer(let offset):
            return "[fp + \(offset)]"
        case .literalValue(let value):
            return "literal \(value)"
        case .rawPointer(let offset):
            return "[raw @ fp + \(offset)]"
        }
    }
    
}
