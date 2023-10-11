extension If {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILIfStatement {
        
        let condition = self.condition.lowerToPIL(lowerer)
        
        let body = self.body.map { $0.lowerToPIL(lowerer) }
        
        let `else` = self.elseIf?.lowerToPIL(lowerer)
        
        return PILIfStatement(condition, body, `else`)
        
    }
    
}
