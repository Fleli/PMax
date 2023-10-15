extension Expression {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILExpression {
        
        // TODO: Member access requires changes to be made to SwiftParse
        /// In `precedence`, users should be able to write specs that end up as `Expression -> Expression #. #identifier` (for example with a `>` marker, as another kind of `:` marker).
        
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
                
                // Not implemented
                fatalError()
                
            } else if unary.rawValue == "&" {
                
                // Not implemented
                fatalError()
                
            }
            
            let pilOperation = PILOperation.unary(operator: unary, arg: lowered_a)
            return PILExpression(pilOperation, lowerer)
            
        case .leftParenthesis_ExpressionrightParenthesis_(_, let expression, _):
            
            return expression.lowerToPIL(lowerer)
            
        case .identifierleftParenthesis_ArgumentsrightParenthesis_(let functionName, _, let arguments, _):
            
            let pilCall = PILCall(functionName, arguments, lowerer)
            let operation = PILOperation.call(pilCall)
            
            return PILExpression(operation, lowerer)
            
        case .integer(let literal):
            
            let varName = lowerer.literalPool.integerLiteral(literal)
            let operation = PILOperation.variable(varName)
            return PILExpression(operation, lowerer)
            
        case .TypeCastleftParenthesis_ExpressionrightParenthesis_(let typeCast, _, let expression, _):
            
            // A type cast is like all other expressions, but we modify the type of it to whatever the programmer specified.
            let annotatedExpression = expression.lowerToPIL(lowerer)
            annotatedExpression.type = PILType(typeCast.type, lowerer)
            
            return annotatedExpression
            
        case .leftParenthesis_ExpressionrightParenthesis_period_identifier(_, let main, _, _, let member):
            
            let loweredMain = main.lowerToPIL(lowerer)
            let operation = PILOperation.member(main: loweredMain, member: member)
            return PILExpression(operation, lowerer)
            
        default:
            
            // Not implemented
            // Remove default, use specific cases instead.
            fatalError()
            
        }
        
    }
    
}
