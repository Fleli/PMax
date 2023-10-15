extension FunctionBodyStatement {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> [PILStatement] {
        
        switch self {
        case .declaration(let declaration):
            
            let type = PILType(declaration.type, lowerer)
            let name = declaration.name
            
            let declarationSucceeded = lowerer.local.declare(type, name)
            
            guard declarationSucceeded else {
                return []
            }
            
            let pilDeclaration = PILStatement.declaration(type: type, name: name)
            
            var statements: [PILStatement] = [pilDeclaration]
            
            if let defaultValue = declaration.value {
                
                let loweredDefaultValue = defaultValue.lowerToPIL(lowerer)
                
                // TODO: Not implemented yet.
                // Declarations with default values require assignments to be fixed first.
                
            }
            
            return statements
            
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
            
        }
        
    }
    
}
