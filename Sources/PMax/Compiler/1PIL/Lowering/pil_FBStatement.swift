extension FunctionBodyStatement {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> [PILStatement] {
        
        switch self {
        case .declaration(let declaration):
            
            return declaration.lowerToPIL(lowerer)
            
        case .assignment(let assignment):
            
            let assignmentStatement = assignment.lowerToPIL(lowerer)
            
            return [assignmentStatement]
            
        case .return(let `return`):
            
            let expression = `return`.expression?.lowerToPIL(lowerer)
            let pilReturn = PILStatement.`return`(expression: expression)
            
            return [pilReturn]
            
        case .if(let `if`):
            
            let wrappedIf = `if`.lowerToPIL(lowerer)
            let pilIf = PILStatement.`if`(wrappedIf)
            
            return [pilIf]
            
        case .while(let `while`):
            
            let condition = `while`.condition.lowerToPIL(lowerer)
            
            lowerer.push()
            
            let body = `while`.body.reduce([PILStatement](), { $0 + $1.lowerToPIL(lowerer) })
            
            lowerer.pop()
            
            let pilWhile = PILStatement.`while`(condition: condition, body: body)
            
            return [pilWhile]
            
        case .call(let call):
            
            // FIXME: This might introduce some hard-to-understand bugs in cases where the called function returns non-void types. Find a way around this.
            
            let type = `Type`.basic(Builtin.void)
            let anonymous = lowerer.autoVariableName("%")
            
            let declaration = Declaration(anonymous, type)
            let loweredDeclaration = declaration.lowerToPIL(lowerer)
            
            let lhsExpression = Expression.identifier(anonymous)
            let rhsExpression = Expression.identifierleftParenthesis_ArgumentsrightParenthesis_(call.function, "(", call.args, ")")
            
            let assignment = Assignment(lhsExpression, rhsExpression)
            let loweredAssignment = assignment.lowerToPIL(lowerer)
            return loweredDeclaration + [loweredAssignment]
            
        }
        
    }
    
}
