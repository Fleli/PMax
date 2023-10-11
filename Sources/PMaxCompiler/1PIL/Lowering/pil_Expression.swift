extension Expression {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILExpression {
        
        switch self {
        case .infixOperator(let binary, let a, let b):
            
            let lowered_a = a.lowerToPIL(lowerer)
            let lowered_b = b.lowerToPIL(lowerer)
            
            let pilOperation = PILOperation.binary(operator: binary, arg1: lowered_a, arg2: lowered_b)
            
            return PILExpression(pilOperation)
            
        case .singleArgumentOperator(let unary, let a):
            
            let lowered_a = a.lowerToPIL(lowerer)
            
            let pilOperation = PILOperation.unary(operator: unary, arg: lowered_a)
            
            return PILExpression(pilOperation)
            
        case .TerminalExpressionTerminal(_, let expression, _):
            
            return expression.lowerToPIL(lowerer)
            
        case .Reference(let reference):
            
            let pilOperation = reference.lowerToPIL(lowerer)
            // TODO: Her må vi finne typen til operasjonen
            return PILExpression(pilOperation)
            
        case .identifierTerminalArgumentsTerminal(let functionName, _, let arguments, _):
            
            // TODO: Implement function call lowering
            fatalError()
            
        case .integer(let literal):
            
            // TODO: Implement literal lowering
            fatalError()
            
        }
        
    }
    
}
