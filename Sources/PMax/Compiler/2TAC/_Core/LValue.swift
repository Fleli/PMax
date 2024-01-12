
/// An `LValue` represents a value with a definitive, known memory location.
/// Note that some expressions, like `x`, may be either `LValue`s or `RValue`s depending on where they occur.
/// Other expressions, like `5` or `x + 3` can never be `LValue`s.
enum LValue: CustomStringConvertible {
    
    /// A stack-allocated variable. Variables declared within a function body are stack-allocated and are found at a certain frame pointer offset known at compile-time.
    case stackAllocated(framePointerOffset: Int)
    
    /// Dereference a pointer. The pointer being dereferenced must be stack-allocated at a certain `framePointerOffset`.
    /// For example, using `framePointerOffset = 3` means finding the variable at `fp + 3`, interpreting its value as an address, and dereferencing that address.
    /// Dereferencing literal values (e.g. `*30`) is allowed, but the compiler will generate some internal variable and set it equal to `30`, and then use its offset as the `framePointerOffset`.
    case dereference(framePointerOffset: Int)
    
    
    /// Since `LValue`s are a subset of `RValue`s, it might make sense to convert an `LValue` to an `RValue`.
    /// This is, for example, used when fetching local variables but using them as RHS of an expression (scopes return them as `LValue`s).
    func treatAsRValue() -> RValue {
        
        switch self {
        case .stackAllocated(let framePointerOffset):
            return .stackAllocated(framePointerOffset: framePointerOffset)
        case .dereference(let framePointerOffset):
            return .dereference(framePointerOffset: framePointerOffset)
        }
        
    }
    
    
    /// A description of the `LValue`.
    var description: String {
        switch self {
        case .stackAllocated(let framePointerOffset):
            return "lvalue(fp + \(framePointerOffset))"
        case .dereference(let framePointerOffset):
            return "lvalue[fp + \(framePointerOffset)]"
        }
    }
    
}
