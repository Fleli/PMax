extension Aspartame {
    
    func lower(_ reference: Reference) -> LoweredExpression {
        
        switch reference {
            
        case .identifier(let identifier):  // identifier
            
            return .directVariable(identifier)
            
        case .intLiteral(let integer):  // integerLiteral
            
            let declaration = newInternalVariable()
            
            let name = declaration.name
            
            let assignment = AspartameStatement.assignIntegerLiteral(lhs: name, literal: integer)
            
            let statements = [declaration.statement, assignment]
            
            return LoweredExpression(name, statements)
            
        case .member(let reference, _, let member):  // reference.member
            
            let loweredReference = lower(reference)
            
            let declaration = newInternalVariable()
            
            let newInternalVariableName = declaration.name
            
            let previousInternalVariable = loweredReference.result
            
            let assignment = AspartameStatement.accessMember(lhs: newInternalVariableName, rhs: previousInternalVariable, member: member)
            
            let statements = loweredReference.statements + [declaration.statement, assignment]
            
            return LoweredExpression(newInternalVariableName, statements)
            
        case .call(let functionName, _, let arguments, _):  // functionName ( Arguments )
            
            var argumentVariables: [String] = []
            var statements: [AspartameStatement] = []
            
            for argument in arguments {
                let expression = argument.expression
                let loweredExpression = lower(expression)
                statements += loweredExpression.statements
                argumentVariables.append(loweredExpression.result)
            }
            
            let internalCallResult = newInternalVariable()
            
            let allStatements = [AspartameStatement.assignFromCall(lhs: internalCallResult.name, function: functionName, arguments: argumentVariables)]
            
            return LoweredExpression(internalCallResult.name, allStatements)
            
        }
        
    }
    
}
