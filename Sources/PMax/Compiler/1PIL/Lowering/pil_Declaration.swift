extension Declaration {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> [PILStatement] {
        
        var type: PILType? = nil
        var statements: [PILStatement] = []
        
        var initialValueHolder: String? = nil
        
        if let initialValue = self.value {
            handleInitialValue(initialValue, &type, &statements, &initialValueHolder, lowerer)
        }
        
        if let explicitSyntacticalType = self.type {
            
            let explicitType = PILType(explicitSyntacticalType, lowerer)
            
            if let inferredType = type, !(inferredType.assignable(to: explicitType)) {
                
                let lhsExpression = PILExpression(PILOperation.variable(name), cast: explicitType)
                lowerer.submitError(PMaxIssue.assignmentTypeMismatch(lhs: lhsExpression, actual: inferredType))
                return []
                
            }
            
            type = explicitType
            
        }
        
        guard let type else {
            lowerer.submitError(PMaxIssue.cannotInferType(variable: name))
            return []
        }
        
        let declarationSucceeded = lowerer.local.declare(type, name)
        
        guard declarationSucceeded else {
            return []
        }
        
        // Add the declaration statement.
        let pilDeclaration = PILStatement.declaration(type: type, name: name)
        statements.append(pilDeclaration)
        
        // Copy the value from the initialValueHolder to the declared variable.
        if let initialValueHolder {
            
            let copyStatement = PILStatement.assignment(
                lhs: PILExpression(PILOperation.variable(name), lowerer),
                rhs: PILExpression(PILOperation.variable(initialValueHolder), lowerer)
            )
            
            statements.append(copyStatement)
            
        }
        
        return statements
        
    }
    
    private func handleInitialValue(_ initialValue: Expression, _ type: inout PILType?, _ statements: inout [PILStatement], _ initialValueHolder: inout String?, _ lowerer: PILLowerer) {
        
        // Infer the type of LHS and assign it to the (temporary) type of the declared variable.
        let inferredType = inferExpressionType(initialValue, lowerer)
        type = inferredType
        
        // Declare a new, intermediate variable that will hold the result of evaluating the initial expression.
        let intermediateVariable = lowerer.newAnonymousVariable
        let intermediateDeclaration = PILStatement.declaration(type: inferredType, name: intermediateVariable)
        lowerer.local.declare(inferredType, intermediateVariable)
        
        // Notify the lowerer function of this new intermediate variable
        initialValueHolder = intermediateVariable
        
        // Create an assignment from the initial value expression to the intermediate variable.
        let syntacticEquivalentAssignment = Assignment(.identifier(intermediateVariable), initialValue)
        let loweredAssignment = syntacticEquivalentAssignment.lowerToPIL(lowerer, true)
        
        // Add (1) the intermediate variable declaration and (2) the assignment statement to the 'statements' variable.
        statements = [intermediateDeclaration, loweredAssignment]
        
    }
    
    private func inferExpressionType(_ expression: Expression, _ lowerer: PILLowerer) -> PILType {
        return expression.lowerToPIL(lowerer).type
    }
    
}
