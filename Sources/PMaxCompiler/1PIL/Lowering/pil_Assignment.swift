extension Assignment {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> PILStatement {
        
        let lhs = self.lhs.lowerToPIL(lowerer)
        var rhs = self.rhs.lowerToPIL(lowerer)
        
        if let sugarOperator = self.operator {
            
            let rw = "\(sugarOperator)"
            
            if let infix = Expression.InfixOperator(rawValue: rw) {
                let newOperation = PILOperation.binary(operator: infix, arg1: lhs, arg2: rhs)
                rhs = PILExpression(newOperation, lowerer)
            } else {
                lowerer.submitError(.invalidSugaredAssignment(operator: rw))
            }
            
        }
        
        if !rhs.type.assignable(to: lhs.type) {
            lowerer.submitError(.assignmentTypeMismatch(lhs: lhs, actual: rhs.type))
        }
        
        return PILStatement.assignment(lhs: lhs, rhs: rhs)
        
    }
    
}
