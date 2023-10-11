extension FunctionBodyStatement {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> [PILStatement] {
        
        switch self {
        case .declaration(let declaration):
            
            let type = PILType(declaration.type, lowerer)
            let pilDecl = PILStatement.declaration(type: type, name: declaration.name)
            
            guard let initValue = declaration.value else {
                return [pilDecl]
            }
            
            let lhs = [declaration.name]
            let pilAssign = PILStatement.assignment(lhs: lhs, rhs: initValue.lowerToPIL(lowerer))
            
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
            let body = `while`.body.reduce([PILStatement](), { $0 + $1.lowerToPIL(lowerer) })
            
            let pilWhile = PILStatement.`while`(condition: condition, body: body)
            
            return [pilWhile]
            
        }
        
    }
    
}
