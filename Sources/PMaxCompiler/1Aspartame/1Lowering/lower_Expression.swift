extension Aspartame {
    
    internal func lower(_ expression: Expression) -> LoweredExpression {
        
        switch expression {
        case .infixOperator(let `operator`, let x, let y):  // x OP y
            let xLowered = lower(x)
            let yLowered = lower(y)
            let call = convertInfixToCall(`operator`.rawValue, lhs: xLowered.result, rhs: yLowered.result)
            return LoweredExpression(call.result, xLowered.statements + yLowered.statements + call.statements)
        case .singleArgumentOperator(let `operator`, let x):  // OP x
            let xLowered = lower(x)
            let call = convertUnaryToCall(`operator`.rawValue, lhs: xLowered.result)
            return LoweredExpression(call.result, xLowered.statements + call.statements)
        case .TerminalExpressionTerminal(_, let e, _):  // ( E )
            return lower(e)
        case .Reference(let reference):  // If we have a deep reference, we break it up so it never consists of more than one level of indirection.
            return lower(reference)
        }
        
    }
    
}
