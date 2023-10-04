extension FunctionLabel {
    
    func decarbonate(_ decarbonator: Decarbonator) {
        
        let environment: Environment = decarbonator.environment
        
        let label = environment.labelFor(self)
        
        for statement in loweredBody {
            
            switch statement {
            case .declaration(let name, let type):
                // If an error is present, the scope will submit it. Nothing needed here.
                environment.active().declare(name, type)
            case .assignment(let lhs, let rhs):
                if let result = environment.active().verifyAssignmentSemantics(lhs, rhs) {
                    
                }
            case .assignIntegerLiteral(let lhs, let literal):
                <#code#>
            case .accessMember(let lhs, let rhs, let member):
                <#code#>
            case .assignFromCall(let lhs, let function, let arguments):
                <#code#>
            case .block(let statements):
                <#code#>
            case .ignoreNextIfZero(let check, let n):
                <#code#>
            case .jumpBack(let n):
                <#code#>
            case .return(let value):
                <#code#>
            }
            
        }
        
    }
    
}
