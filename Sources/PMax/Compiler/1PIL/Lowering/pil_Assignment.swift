extension Assignment {
    
    func lowerToPIL(_ lowerer: PILLowerer, _ inferLHSType: Bool = false) -> PILStatement {
        
        let lhs = self.lhs.lowerToPIL(lowerer)
        var rhs = self.rhs.lowerToPIL(lowerer)
        
        if let sugarOperator = self.operator {
            
            let rw = "\(sugarOperator)"
            
            if let infix = Expression.InfixOperator(rawValue: rw) {
                let newOperation = PILOperation.binary(operator: infix, arg1: lhs, arg2: rhs)
                rhs = PILExpression(newOperation, lowerer)
            } else {
                lowerer.submitError(PMaxIssue.invalidSugaredAssignment(operator: rw))
            }
            
        }
        
        if inferLHSType {
            lhs.type = rhs.type
        }
        
        if !rhs.type.assignable(to: lhs.type) {
            lowerer.submitError(PMaxIssue.assignmentTypeMismatch(lhs: lhs, actual: rhs.type))
        }
        
        if lhs.type == .void {
            lowerer.submitError(PMaxWarning.assignToVoid(lhs: lhs))
        }
        
        return PILStatement.assignment(lhs: lhs, rhs: rhs)
        
    }
    
}
