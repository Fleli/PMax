extension If {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILIfStatement {
        
        let condition = self.condition.lowerToPIL(lowerer)
        
        lowerer.push()
        
        let body = self.body.reduce([PILStatement](), { $0 + $1.lowerToPIL(lowerer) })
        
        lowerer.pop()
        
        lowerer.push()
        
        let `else`: PILIfStatement?
        
        switch self.else {
        case nil:
            
            `else` = nil
            
        case .uncdoncitional(let unconditionalElse):
            
            // If the `else` is unconditional, we tranform it to the condition `if 1`, which always evaluates to `true`.
            // This introduces a small performance penalty in the generated executable.
            // TODO: Introduce an optimization that removes this penalty.
            let ordinaryElseIf = If(Expression.integer("1"), unconditionalElse.body)
            `else` = ordinaryElseIf.lowerToPIL(lowerer)
            
        case .conditional(let elseIf):
            
            // In the case of en `else if`, we just lower it since the system is built around else-ifs already.
            `else` = elseIf.lowerToPIL(lowerer)
            
        }
        
        lowerer.pop()
        
        return PILIfStatement(condition, body, `else`)
        
    }
    
}
