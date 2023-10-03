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
        
        // Since the declaration is given an initial value, we must compute it. We delegate this to the expression itself.
        // TODO: Convert the initial value to Aspartame statements and return that code, plus an assignment to actually set the value of the declared variable.
        
        fatalError("Initial value lowering not implemented yet.")
        
    }
    
}
