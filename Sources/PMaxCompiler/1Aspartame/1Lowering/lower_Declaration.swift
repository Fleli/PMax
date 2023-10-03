extension Aspartame {
    
    internal func lower(_ declaration: Declaration) -> [AspartameStatement] {
        
        let name = declaration.name
        
        guard let type = DataType(declaration.type, self) else {
            // Error already produced by the DataType initializer, so nothing to check.
            // TODO: Consider allowing the Declaration through, but with an <<<error type>>> type or something along those lines.
            return []
        }
        
        let loweredDeclaration = AspartameStatement.declaration(name: name, type: type)
        
        guard let initialValue = declaration.value else {
            // No initial value, so we just return the declaration (there is nothing else to compute).
            return [loweredDeclaration]
        }
        
        // Since the declaration is given an initial value, we must compute it. We delegate the computation to the expression itself, and use its final intermediate variable to assign a new value.
        let loweredExpression = lower(initialValue)
        
        let result = loweredExpression.result
        let assignment = AspartameStatement.assignment(lhs: name, rhs: result)
        
        return [loweredDeclaration] + loweredExpression.statements + [assignment]
        
    }
    
}
