extension Assignment {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILStatement {
        
        let lhs = self.lhs.lowerToPIL(lowerer)
        let rhs = self.rhs.lowerToPIL(lowerer)
        
        if !rhs.type.assignable(to: lhs.type) {
            lowerer.submitError(.assignmentTypeMismatch(lhs: lhs, actual: rhs.type))
        }
        
        return PILStatement.assignment(lhs: lhs, rhs: rhs)
        
    }
    
}
