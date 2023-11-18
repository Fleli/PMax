
// TODO: Referring to values as 'locations' is somewhat unprecise.
// Consider instead using a clear distinction between LValues (left-hand side values, i.e. assignable expressions) and RValues (right-hand side values)
// Clearly separating between the two would greatly increase clarity and readability, remove many (unreachable) fatalError() calls and generally reduce the probability of errors. Carrying around information about the value's context may also increase the quality of error messages.

indirect enum Location: CustomStringConvertible {
    
    /// A `.framePointer` case represents a certain offset from the current frame pointer. This is used for referring to local variables.
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
