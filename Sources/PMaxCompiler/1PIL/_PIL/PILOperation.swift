enum PILOperation {
    
    typealias Unary = Expression.SingleArgumentOperator
    typealias Binary = Expression.InfixOperator
    
    case unary(operator: Unary, arg: PILExpression)
    case binary(operator: Binary, arg1: PILExpression, arg2: PILExpression)
    
    case reference(PILReference)
    
    func synthesizeType() -> PILType {
        // TODO: Synthesize a type from subexpressions, or simply fetch from reference.
        return .void
    }
    
}
