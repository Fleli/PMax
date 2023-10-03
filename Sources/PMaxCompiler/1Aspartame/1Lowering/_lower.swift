extension FunctionLabel {
    
    internal var currentLabel: Label {
        labels[labels.count - 1]
    }
    
    internal func switchLabel(to newLabel: Label) {
        labels.append(newLabel)
    }
    
    internal func lowerToAspartame() -> [Label] {
        
        let initLabel = Label()
        labels = [initLabel]
        
        // TODO: Go through parameters
        
        let statements = underlyingFunctionDeclaration.body
        let loweredBody = aspartame.lower(statements, within: self)
        
        // TODO: Include everyting else as well.
        return labels
        
    }
    
    
}
