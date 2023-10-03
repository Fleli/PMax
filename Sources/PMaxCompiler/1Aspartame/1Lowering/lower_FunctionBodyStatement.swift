extension Aspartame {
    
    // TODO: Look closer at how this function interacts with the rest of the code.
    func lower(_ statements: FunctionBodyStatements, within functionLabel: FunctionLabel) -> [AspartameStatement] {
        
        // Go through each statement in the underlying function declaration
        for statement in statements {
            
            // Any time the statement is one that needs jumps, the statement itself generates a new label and notifies the enclosing statement via a `ConditionResult` type. Subsequent statements in the conitional's enclosing statements (that is, statements after the conditional) are then located within this label. In other words, the statement that _does the branch_ is responsible for creating a new path (label) for further execution.
            // A statement like `if` or `while` that includes conditionals, will keep putting statements under the same label they are located under, so no jump is required before entering the conditionals within them.
            
            let lowered: [AspartameStatement]
            
            switch statement {
            case .declaration(let declaration):
                lowered = lower(declaration)
            case .assignment(let assignment):
                lowered = lower(assignment)
            case .return(_):
                fatalError()
            case .if(let `if`):
                fatalError()
            case .while(_):
                fatalError()
            }
            
        }
        
        // TODO
        return []
        
    }
    
}
