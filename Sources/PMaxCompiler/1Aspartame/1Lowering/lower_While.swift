extension Aspartame {
    
    internal func lower(_ while: While) -> [AspartameStatement] {
        
        let loweredCondition = lower(`while`.condition)
        
        let loweredResult = loweredCondition.result
        let loweredConditionStatements = loweredCondition.statements
        
        // We want to skip both the block for the while loop _and_ the jump afterwards that normally takes us back to calculating the condition.
        let skipIfZero = AspartameStatement.ignoreNextIfZero(check: loweredResult, n: 2)
        
        let loweredBody = lower(`while`.body)
        let wrapped = AspartameStatement.block(statements: loweredBody)
        
        // We want to jump back to before loweredConditionStatements. The exact semantics of `n` will depend on implementation in the next step.
        // TODO: Consider adding some sort of automatic tracking instead of a predefined number of statements to jump back. That way, optimizations in the condition evaluation won't really affect the jumping mechanism.
        let n = loweredConditionStatements.count + 2
        let jumpBackToCondition = AspartameStatement.jumpBack(n: n)
        
        return loweredConditionStatements + [skipIfZero, wrapped, jumpBackToCondition]
        
    }
    
}
