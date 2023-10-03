extension Aspartame {
    
    internal func lower(_ expression: Expression) -> IntermediateResult {
        
        
        switch expression {
        case .infixOperator(let `operator`, let x, let y):  // x OP y
            // TODO: Find the macro (or function) that represents this operation and return a call to that.
            break
        case .singleArgumentOperator(let `operator`, let x):  // OP x
            // TODO: Find the macro (or function) that represents this operation and return a call to that.
            break
        case .TerminalExpressionTerminal(_, let e, _):  // ( E )
            return lower(e)
        case .Reference(let reference):  // If we have a deep reference, we break it up so it never consists of more than one level of indirection.
            return lower(reference)
        }
        
        // TODO: Remove once `break` statements are removed.
        fatalError()
        
    }
    
}
