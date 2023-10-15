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
            let lowered = expression.lowerToPIL(lowerer)
            lowered.type = PILType(typeCast.type, lowerer)
            
            return lowered
            
        case .leftParenthesis_ExpressionrightParenthesis_period_identifier(_, let main, _, _, let member):
            
            let loweredMain = main.lowerToPIL(lowerer)
            let operation = PILOperation.member(main: loweredMain, member: member)
            
            return PILExpression(operation, lowerer)
            
        case .asterisk_Expression(_, let expression):
            
            let lowered = expression.lowerToPIL(lowerer)
            let dereference = PILOperation.dereference(lowered)
            
            return PILExpression(dereference, lowerer)
            
        case .ampersand_Expression(_, let expression):
            
            let lowered = expression.lowerToPIL(lowerer)
            let addressOf = PILOperation.addressOf(lowered)
            
            return PILExpression(addressOf, lowerer)
            
        case .identifier(let identifier):
            
            let operation = PILOperation.variable(identifier)
            
            return PILExpression(operation, lowerer)
            
        case .leftParenthesis_ExpressionrightParenthesis_hyphen_greaterThan_identifier(_, let expression, _, _, let member):
            
            let loweredExpression = expression.lowerToPIL(lowerer)
            let dereferenced = PILOperation.dereference(loweredExpression)
            let dereferencedExpression = PILExpression(dereferenced, lowerer)
            
            let memberAccess = PILOperation.member(main: dereferencedExpression, member: member)
            let composite = PILExpression(memberAccess, lowerer)
            
            return composite
            
        }
        
    }
    
}
