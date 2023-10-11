enum PILOperation: CustomStringConvertible {
    
    typealias Unary = Expression.SingleArgumentOperator
    typealias Binary = Expression.InfixOperator
    
    case unary(operator: Unary, arg: PILExpression)
    case binary(operator: Binary, arg1: PILExpression, arg2: PILExpression)
    
    /// A `.reference` operation simply points to a nesting of members. The 0th element means a variable in the local scope, the 1st is a member of that variable, the 2nd is a member of that, etc.
    case reference([String])
    
    case call(PILCall)
    
    var description: String {
        switch self {
        case .unary(let `operator`, let arg):
            return "(\(`operator`.rawValue)\(arg.description))"
        case .binary(let `operator`, let arg1, let arg2):
            return "(\(arg1.description)\(`operator`.rawValue)\(arg2.description))"
        case .reference(let array):
            return "\(array.reduce("", {$0 + $1 + "."}).dropLast())"
        case .call(let call):
            return call.description
        }
    }
    
    func synthesizeType() -> PILType {
        // TODO: Synthesize a type from subexpressions, or simply fetch from reference.
        // TODO: This may require declarations to be added as we go (that is, name binding may have to be done as we lower the statement tree).
        return .void
    }
    
}
