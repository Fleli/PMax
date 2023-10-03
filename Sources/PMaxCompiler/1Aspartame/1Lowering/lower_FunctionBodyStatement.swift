extension Aspartame {
    
    func lower(_ statements: FunctionBodyStatements) -> [AspartameStatement] {
        
        var lowered: [AspartameStatement] = []
        
        for statement in statements {
            
            switch statement {
            case .declaration(let declaration):
                lowered += lower(declaration)
            case .assignment(let assignment):
                lowered += lower(assignment)
            case .return(let `return`):
                lowered += lower(`return`)
            case .if(let `if`):
                lowered += lower(`if`)
            case .while(let `while`):
                lowered += lower(`while`)
            }
            
        }
        
        return lowered
        
    }
    
}
