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
                
                // TODO: Consider reordering and generating an intermediate variable here since default values in declarations shouldn't really be able to refer to themselves. In other words, we change the order to:
                // (1) Declare a new non-colliding variable
                // (2) Assign the default value to that new variable
                // (3) Declare the variable we're interested in (`name`)
                // (4) Assign the intermediate variable to the actual variable
                // That way, use of `name` in the default value will refer to `name` in outer scopes and can be used unambiguously.
                
                let syntacticEquivalentAssignment = Assignment(.identifier(name), defaultValue)
                let loweredAssignment = syntacticEquivalentAssignment.lowerToPIL(lowerer)
                
                statements.append(loweredAssignment)
                
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
