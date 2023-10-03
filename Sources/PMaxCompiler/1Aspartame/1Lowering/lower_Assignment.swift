extension Aspartame {
    
    func lower(_ assignment: Assignment) -> [AspartameStatement] {
        
        let lhs = assignment.lhs
        
        let loweredRhs = lower(assignment.rhs)
        
        let newAssignment = AspartameStatement.assignment(lhs: lhs, rhs: loweredRhs.result)
        return loweredRhs.statements + [newAssignment]
        
    }
    
}
