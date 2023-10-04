extension Aspartame {
    
    func lower(_ assignment: Assignment) -> [AspartameStatement] {
        
        // TODO: Change assignment to allow references, since expressions of the type `a.b = x;` are extremely important.
        
        let lhs = assignment.lhs
        
        let loweredRhs = lower(assignment.rhs)
        
        let newAssignment = AspartameStatement.assignment(lhs: lhs, rhs: loweredRhs.result)
        return loweredRhs.statements + [newAssignment]
        
    }
    
}
