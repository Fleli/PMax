extension FunctionLabel {
    
    var currentLabel: Label {
        body[body.count - 1]
    }
    
    internal func lowerToAspartame() {
        
        let initLabel = Label()
        body = [initLabel]
        
        // TODO: Also go through parameters
        
        // Go through each statement in the underlying function declaration
        for statement in underlyingFunctionDeclaration.body {
            
            // Any time the statement is one that needs jumps, the enclosing statement generates a new label: This label represents where the statement should jump to whenever it is finished with its tasks.
            
            let lowered: [AspartameStatement]
            
            switch statement {
            case .declaration(let declaration):
                lowered = aspartame.lower(declaration)
            case .assignment(let assignment):
                <#code#>
            case .return(let `return`):
                <#code#>
            case .if(let `if`):
                <#code#>
            case .while(let `while`):
                <#code#>
            }
            
            
            
        }
        
        
    }
    
    
}
