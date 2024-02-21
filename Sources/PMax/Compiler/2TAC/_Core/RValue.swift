
/// An `RValue` represents a value that does not necessarily have a definitive memory location. The value is calculated at runtime, and may be assigned to a memory location.
/// Note that some expressions, like `x`, may be either `LValue`s or `RValue`s depending on where they occur.
/// Other expressions, like `5` or `x + 3` can only be `RValue`s since they can only occur on the right-hand side of an `=` sign.
enum RValue: CustomStringConvertible {
    
    /// A stack-allocated variable. Variables declared within a function body are stack-allocated and are found at a certain frame pointer offset known at compile-time.
    case stackAllocated(framePointerOffset: Int)
    
    /// An integer literal.
    case integerLiteral(value: Int)
    
    /// A string literal
    case stringLiteral(globalPoolOffset: Int)
    
    /// Dereference a pointer. The pointer being dereferenced must be stack-allocated at a certain `framePointerOffset`.
    /// For example, using `framePointerOffset = 3` means finding the variable at `fp + 3`, interpreting its value as an address, and dereferencing that address.
    /// Dereferencing literal values (e.g. `*30`) is allowed, but the compiler will generate some internal variable and set it equal to `30`, and then use its offset as the `framePointerOffset`.
    case dereference(framePointerOffset: Int)
    
    
    /// It might make sense to treat an `RValue` as an `LValue` in very specific cases.
    /// Since `RValue`s are a superset of `LValue`s however, it could be a meaningless operation. In such cases, this function `fatalError`s.
    func treatAsLValue() -> LValue {
        
        switch self {
        case .stackAllocated(let framePointerOffset):
            return .stackAllocated(framePointerOffset: framePointerOffset)
        case .integerLiteral(let value):
            fatalError("Cannot convert RValue '\(self.description)' to LValue (integer literal \(value)).")
        case .stringLiteral(let globalPoolOffset):
            fatalError("String literal at global pool offset \(globalPoolOffset) cannot be treated as an LValue.")
        case .dereference(let framePointerOffset):
            return .dereference(framePointerOffset: framePointerOffset)
        }
        
    }
    
    
    /// A description of the `RValue`.
    var description: String {
        switch self {
        case .stackAllocated(let framePointerOffset):
            return "rvalue[fp + \(framePointerOffset)]"
        case .integerLiteral(let value):
            return "rvalue(\(value))"
        case .stringLiteral(let globalPoolOffset):
            return "rvalue(string @ \(globalPoolOffset))"
        case .dereference(let framePointerOffset):
            return "rvalue(*[fp + \(framePointerOffset)])"
        }
    }
    
}
