extension Expression {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILExpression {
        
//      IMPLEMENTED
//      infix operators         a + b
//      unary operators         - a
//      grouping                ( E )
//      function calls          a ( Args )
//      integer literals        5
//      type casts              (as X) (E)
//      member access           (E) . m
//      MISSING
//      address-of              & E
//      dereference             * E
//      identifier              x
//
//
//
        
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
            let annotatedExpression = expression.lowerToPIL(lowerer)
            annotatedExpression.type = PILType(typeCast.type, lowerer)
            
            return annotatedExpression
            
        case .leftParenthesis_ExpressionrightParenthesis_period_identifier(_, let main, _, _, let member):
            
            let loweredMain = main.lowerToPIL(lowerer)
            let operation = PILOperation.member(main: loweredMain, member: member)
            return PILExpression(operation, lowerer)
            
        case .asterisk_Expression(_, let expression):
            
            fatalError()
            
        case .ampersand_Expression(_, let expression):
            
            fatalError()
            
        case .identifier(let identifier):
            
            fatalError()
            
        }
        
    }
    
}
