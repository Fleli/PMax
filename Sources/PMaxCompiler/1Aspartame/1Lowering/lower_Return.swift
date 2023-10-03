extension Aspartame {
    
    internal func lower(_ `return`: Return) -> [AspartameStatement] {
        
        var internalVariable: String? = nil
        var statements: [AspartameStatement] = []
        
        if let value = `return`.expression {
            
            let loweredExpression = lower(value)
            
            let internalVar = newInternalVariable()
            
            let assignment = AspartameStatement.assignment(lhs: internalVar.name, rhs: loweredExpression.result)
            
            statements = loweredExpression.statements + [internalVar.statement, assignment]
            
            internalVariable = internalVar.name
            
        }
        
        let returnStatement = AspartameStatement.return(value: internalVariable)
        statements.append(returnStatement)
        
        return statements
        
    }
    
}
