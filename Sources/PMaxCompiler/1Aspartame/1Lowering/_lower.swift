extension FunctionLabel {
    
    internal func lowerToAspartame() {
        
        // TODO: Go through parameters
        
        let statements = underlyingFunctionDeclaration.body
        
        self.loweredBody = aspartame.lower(statements)
        
    }
    
    
}
