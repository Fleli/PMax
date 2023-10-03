extension Aspartame {
    
    internal func lower(_ `return`: Return) -> [AspartameStatement] {
        
        var internalVariable: String? = nil
        var statements: [AspartameStatement] = []
        
        if let value = `return`.expression {
            
            let loweredExpression = lower(value)
            let internalVar = newInternalVariable()
            
            statements = loweredExpression.statements + [internalVar.statement]
            
            internalVariable = internalVar.name
            
        }
        
        let returnStatement = AspartameStatement.return(value: internalVariable)
        statements.append(returnStatement)
        
        return statements
        
    }
    
}
