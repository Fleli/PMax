extension FunctionLabel {
    
    var currentLabel: Label {
        body[body.count - 1]
    }
    
    private func switchLabel(to newLabel: Label) {
        body.append(newLabel)
    }
    
    internal func lowerToAspartame() {
        
        let initLabel = Label()
        body = [initLabel]
        
        // TODO: Also go through parameters
        
        // Go through each statement in the underlying function declaration
        for statement in underlyingFunctionDeclaration.body {
            
            // Any time the statement is one that needs jumps, the statement itself generates a new label and notifies the enclosing statement via a `ConditionResult` type. Subsequent statements in the conitional's enclosing statements (that is, statements after the conditional) are then located within this label. In other words, the statement that _does the branch_ is responsible for creating a new path (label) for further execution.
            // A statement like `if` or `while` that includes conditionals, will keep putting statements under the same label they are located under, so no jump is required before entering the conditionals within them.
            
            let newLabel: Label?
            let lowered: [AspartameStatement]
            
            switch statement {
            case .declaration(let declaration):
                lowered = aspartame.lower(declaration)
                newLabel = nil
            case .assignment(let assignment):
                lowered = aspartame.lower(assignment)
                newLabel = nil
            case .return(_):
                // TODO: Må finne call/return convention.
                lowered = []
                newLabel = nil
            case .if(let `if`):
                let conditionResult = aspartame.lower(`if`, within: self)
                lowered = conditionResult.lowered
                newLabel = conditionResult.newPath
            case .while(let `while`):
                let conditionResult = aspartame.lower(`while`, within: self)
                lowered = conditionResult.lowered
                newLabel = conditionResult.newPath
            }
            
            currentLabel.includeCode(lowered)
            
            if let newLabel {
                switchLabel(to: newLabel)
            }
            
        }
        
        
    }
    
    
}
