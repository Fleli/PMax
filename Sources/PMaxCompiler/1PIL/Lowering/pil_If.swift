extension If {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILIfStatement {
        
        let condition = self.condition.lowerToPIL(lowerer)
        
        let body = self.body.reduce([PILStatement](), { $0 + $1.lowerToPIL(lowerer) })
        
        let `else` = self.elseIf?.lowerToPIL(lowerer)
        
        return PILIfStatement(condition, body, `else`)
        
    }
    
}
