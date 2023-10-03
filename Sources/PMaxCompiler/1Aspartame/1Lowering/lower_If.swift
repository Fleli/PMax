extension Aspartame {
    
    internal func lower(_ `if`: If) -> [AspartameStatement] {
        
        let loweredCondition = lower(`if`.condition)
        
        let loweredResult = loweredCondition.result
        let loweredConditionStatements = loweredCondition.statements
        
        let skipIfZero = AspartameStatement.ignoreNextIfZero(check: loweredResult)
        
        let loweredBody = lower(`if`.body)
        let wrapped = AspartameStatement.block(statements: loweredBody)
        
        if `if`.elseIf != nil {
            print("else if is not yet supported. It is ignored for now.")
        }
        
        return loweredConditionStatements + [skipIfZero, wrapped]
        
    }
    
}
