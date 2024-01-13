extension Expression {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILExpression {
        
        switch self {
            
        case .infixOperator(let binary, let a, let b):
            
            if binary.rawValue == "->" {
                return lowerToPILAsMemberThroughPointer(lowerer, a, b)
            } else if binary.rawValue == "." {
                return lowerToPILAsMember(lowerer, a, b)
            }
            
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
            
            let operation = PILOperation.integerLiteral(literal)
            return PILExpression(operation, lowerer)
            
        case .TypeCastleftParenthesis_ExpressionrightParenthesis_(let typeCast, _, let expression, _):
            
            // A type cast is like all other expressions, but we modify the type of it to whatever the programmer specified.
            let lowered = expression.lowerToPIL(lowerer)
            lowered.type = PILType(typeCast.type, lowerer)
            
            return lowered
            
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
            
        case .string(_):
            
            lowerer.submitError(PMaxIssue.stringsAreNotSupported)
            return PILExpression.init(.integerLiteral("0"), cast: .error)
            
        case .Sizeof(let sizeof):
            
            let pilType = PILType(sizeof.type, lowerer)
            let pilSizeof = PILOperation.sizeof(type: pilType)
            let pilExpr = PILExpression(pilSizeof, lowerer)
            
            return pilExpr
            
        }
        
    }
    
    
    func lowerToPILAsMemberThroughPointer(_ lowerer: PILLowerer, _ expression: Expression, _ memberExpression: Expression) -> PILExpression {
        
        guard case .identifier(let member) = memberExpression else {
            lowerer.submitError(PMaxIssue.invalidMember(invalid: memberExpression.lowerToPIL(lowerer)))
            let placeholder = expression.lowerToPIL(lowerer)
            placeholder.type = .error
            return placeholder
        }
        
        let loweredExpression = expression.lowerToPIL(lowerer)
        let dereferenced = PILOperation.dereference(loweredExpression)
        let dereferencedExpression = PILExpression(dereferenced, lowerer)
        
        let memberAccess = PILOperation.member(main: dereferencedExpression, member: member)
        let composite = PILExpression(memberAccess, lowerer)
        
        return composite
        
    }
    
    func lowerToPILAsMember(_ lowerer: PILLowerer, _ main: Expression, _ memberExpression: Expression) -> PILExpression {
        
        guard case .identifier(let member) = memberExpression else {
            lowerer.submitError(PMaxIssue.invalidMember(invalid: memberExpression.lowerToPIL(lowerer)))
            let placeholder = main.lowerToPIL(lowerer)
            placeholder.type = .error
            return placeholder
        }
        
        let loweredMain = main.lowerToPIL(lowerer)
        let operation = PILOperation.member(main: loweredMain, member: member)
        
        return PILExpression(operation, lowerer)
        
    }
    
}
