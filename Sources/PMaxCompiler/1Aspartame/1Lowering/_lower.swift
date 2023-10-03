extension FunctionLabel {
    
    internal func lowerToAspartame() {
        
        // TODO: Go through parameters
        
        let statements = underlyingFunctionDeclaration.body
        let loweredBody = aspartame.lower(statements, within: self)
        
    }
    
    
}
