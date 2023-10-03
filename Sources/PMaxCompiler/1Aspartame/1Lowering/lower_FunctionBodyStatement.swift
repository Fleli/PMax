extension Aspartame {
    
    // TODO: Look closer at how this function interacts with the rest of the code.
    func lower(_ statements: FunctionBodyStatements) -> [AspartameStatement] {
        
        var lowered: [AspartameStatement] = []
        
        for statement in statements {
            
            switch statement {
            case .declaration(let declaration):
                lowered += lower(declaration)
            case .assignment(let assignment):
                lowered += lower(assignment)  // Not implemented because the grammar needs an update first.
            case .return(_):
                fatalError()
            case .if(let `if`):
                lowered += lower(`if`)
            case .while(let `while`):
                lowered += lower(`while`)
            }
            
        }
        
        return lowered
        
    }
    
}
