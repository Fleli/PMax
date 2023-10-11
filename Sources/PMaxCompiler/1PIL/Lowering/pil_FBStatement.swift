extension FunctionBodyStatement {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILStatement {
        
        switch self {
        case .declaration(let declaration):
            let type = PILType(declaration.type, lowerer)
            return PILStatement.declaration(type: type, name: declaration.name)
            // TODO: Add assignment
        case .assignment(let assignment):
            
            let lhs = assignment.lhs.flattenReference()
            let rhs = assignment.rhs.lowerToPIL(lowerer)
            
            return PILStatement.assignment(lhs: lhs, rhs: rhs)
            
        case .return(let `return`):
            
            let expression = `return`.expression?.lowerToPIL(lowerer)
            return .`return`(expression: expression)
            
        case .if(let `if`):
            
            let pilIf = `if`.lowerToPIL(lowerer)
            return .`if`(pilIf)
            
        case .while(let `while`):
            
            let condition = `while`.condition.lowerToPIL(lowerer)
            let body = `while`.body.map { $0.lowerToPIL(lowerer) }
            
            return .`while`(condition: condition, body: body)
            
        }
        
    }
    
}
