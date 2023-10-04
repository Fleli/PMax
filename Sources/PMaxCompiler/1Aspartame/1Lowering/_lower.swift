extension FunctionLabel {
    
    internal func lowerToAspartame() {
        
        var statements: [AspartameStatement] = []
        
        // TODO: Check that this is in line with the calling convention: Parameters must be available (and not overwritten) when execution begins.
        // Declare each parameter
        for parameter in underlyingFunctionDeclaration.parameters {
            
            let name = parameter.name
            
            guard let type = DataType(parameter.type, aspartame) else {
                // Error is submitted by DataType initializer
                continue
            }
            
            let declaration = AspartameStatement.declaration(name: name, type: type)
            statements.append(declaration)
            
        }
        
        statements += aspartame.lower(underlyingFunctionDeclaration.body)
        
        self.loweredBody = statements
        
    }
    
    
}
