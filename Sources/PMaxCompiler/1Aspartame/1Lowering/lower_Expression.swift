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
        case .Reference(let reference):
            // TODO: Find the last assigned variable in the reference. Return the name of that, so that the caller knows what value to fetch when assigning.
            break
        }
        
        // TODO: Remove once `break` statements are removed.
        return .init(resultName: "NIL", statements: [])
        
    }
    
}
