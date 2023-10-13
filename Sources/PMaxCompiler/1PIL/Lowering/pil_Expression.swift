extension Expression {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILExpression {
        
        switch self {
        case .infixOperator(let binary, let a, let b):
            
            let lowered_a = a.lowerToPIL(lowerer)
            let lowered_b = b.lowerToPIL(lowerer)
            
            let pilOperation = PILOperation.binary(operator: binary, arg1: lowered_a, arg2: lowered_b)
            
            return PILExpression(pilOperation, lowerer)
            
        case .singleArgumentOperator(let unary, let a):
            
            let lowered_a = a.lowerToPIL(lowerer)
            
            // Pointer dereference er et special case
            if unary.rawValue == "*" {
                
                let pilOperation = PILOperation.dereference(lowered_a)
                return PILExpression(pilOperation, lowerer)
                
            } else if unary.rawValue == "&" {
                
                guard let pointee = lowered_a.asFlattenedReference() else {
                    lowerer.submitError(.cannotFindAddressOfNonReference)
                    let pilOperation = PILOperation.unary(operator: unary, arg: lowered_a)
                    return PILExpression(pilOperation, lowerer)
                }
                
                let pilOperation = PILOperation.addressOf(pointee)
                return PILExpression(pilOperation, lowerer)
                
            }
            
            let pilOperation = PILOperation.unary(operator: unary, arg: lowered_a)
            return PILExpression(pilOperation, lowerer)
            
        case .TerminalExpressionTerminal(_, let expression, _):
            
            return expression.lowerToPIL(lowerer)
            
        case .Reference(let reference):
            
            let pilOperation = reference.lowerToPIL(lowerer)
            return PILExpression(pilOperation, lowerer)
            
        case .identifierTerminalArgumentsTerminal(let functionName, _, let arguments, _):
            
            let pilCall = PILCall(functionName, arguments, lowerer)
            let operation = PILOperation.call(pilCall)
            
            return PILExpression(operation, lowerer)
            
        case .integer(let literal):
            
            let varName = lowerer.literalPool.integerLiteral(literal)
            let operation = PILOperation.reference([varName])
            return PILExpression(operation, lowerer)
            
        case .TypeCastTerminalExpressionTerminal(let typeCast, _, let expression, _):
            
            // A type cast is like all other expressions, but we modify the type of it to whatever the programmer specified.
            let annotatedExpression = expression.lowerToPIL(lowerer)
            annotatedExpression.type = PILType(typeCast.type, lowerer)
            
            return annotatedExpression
            
        }
        
    }
    
}
