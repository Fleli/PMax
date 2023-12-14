
// TODO: Referring to values as 'locations' is somewhat unprecise.
// Consider instead using a clear distinction between LValues (left-hand side values, i.e. assignable expressions) and RValues (right-hand side values)
// Clearly separating between the two would greatly increase clarity and readability, remove many (unreachable) fatalError() calls and generally reduce the probability of errors. Carrying around information about the value's context may also increase the quality of error messages.

// TODO: Do a thorough walkthrough of where (and how) `Location` is used. Split into several (orthogonal) enums tailored for each use case.
// The use of `Location` throughout the compiler's late stages is flat out terrible.
// It is used for several different purposes, leading to weird switch statements where some cases are marked as unreachable etc.
// It is also highly error prone, and difficult to maintain (simply because it is illogical).

indirect enum Location: CustomStringConvertible {
    
    /// A `.framePointer` case represents a certain offset from the current frame pointer. This is used for referring to local variables.
    case framePointer(offset: Int)
    
    /// A `.literalValue` case does not really represent a memory location, but rather the direct use of a literal integer. This is (for example) used to offset in member references or to add literals to values.
    case literalValue(value: Int)
    
    /// A `.rawPointer(offset:)` represents a pointer. Raw pointers never store the actual address they point to. Instead, they refer to a variable on the stack (at a certain `offset`) that stores the address they point to.
    case rawPointer(RawPointerValue)
    
    
    var description: String {
        switch self {
        case .framePointer(let offset):
            return "[fp + \(offset)]"
        case .literalValue(let value):
            return "literal \(value)"
        case .rawPointer(let offset):
            return "[raw @ \(offset)]"
        }
    }
    
}

enum RawPointerValue: CustomStringConvertible {
    
    /// The value used as address is a literal.
    case literal(Int)
    
    /// The address is stored as a variable at a given frame pointer offset.
    case framePointerOffset(Int)
    
    
    var description: String {
        switch self {
        case .literal(let int):
            return "literal \(int)"
        case .framePointerOffset(let int):
            return "fp + \(int)"
        }
    }
    
}

