extension FunctionBodyStatement {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> [PILStatement] {
        
        // Declarations notify the lowerer's local scope of the new variable.
        // As expressions are lowered, we check (via reference lowering) that the variables they refer to exist.
        // Thus, no statements _here_ need to verify that the variables they use actually exist.
        
        switch self {
        case .declaration(let declaration):
            
            let type = PILType(declaration.type, lowerer)
            let pilDecl = PILStatement.declaration(type: type, name: declaration.name)
            
            lowerer.local.declare(type, declaration.name)
            
            guard let initValue = declaration.value else {
                return [pilDecl]
            }
            
            let lhs = [declaration.name]
            let pilAssign = PILStatement.assignment(lhs: lhs, rhs: initValue.lowerToPIL(lowerer))
            
            // TODO: Should change this so that if `x` is declared, you can't use `x` in its rhs (either disallow, produce warning or try to use `x` from an outer scope)
            
            // TODO: Consider adding a temporary variable that is assigned _before_ `x` is declared, and then assign that to `x`. Be wary of any cryptic error messages resulting from this, though.
            
            return [pilDecl, pilAssign]
            
        case .assignment(let assignment):
            
            let lhs = assignment.lhs.flattenReference()
            let rhs = assignment.rhs.lowerToPIL(lowerer)
            
            let pilAssign = PILStatement.assignment(lhs: lhs, rhs: rhs)
            
            return [pilAssign]
            
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
