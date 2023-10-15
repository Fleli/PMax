extension Assignment {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILStatement {
        
        let lhs = self.lhs.lowerToPIL(lowerer)
        let rhs = self.rhs.lowerToPIL(lowerer)
        
        let assignment = PILStatement.assignment(lhs: lhs, rhs: rhs)
        
        return assignment
        
    }
    
}
