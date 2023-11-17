extension If {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILIfStatement {
        
        let condition = self.condition.lowerToPIL(lowerer)
        
        lowerer.push()
        
        let body = self.body.reduce([PILStatement](), { $0 + $1.lowerToPIL(lowerer) })
        
        lowerer.pop()
        
        lowerer.push()
        
        let `else` = self.elseIf?.lowerToPIL(lowerer)
        
        lowerer.pop()
        
        return PILIfStatement(condition, body, `else`)
        
    }
    
}
