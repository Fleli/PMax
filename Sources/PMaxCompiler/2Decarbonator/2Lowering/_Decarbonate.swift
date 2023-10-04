extension FunctionLabel {
    
    func decarbonate(_ decarbonator: Decarbonator) {
        
        let environment: Environment = decarbonator.environment
        
        var label = environment.label(name)
        
        for statement in loweredBody {
            
            switch statement {
            case .declaration(let name, let type):
                environment.active().declareSemantics(name, type)
            case .assignment(let lhs, let rhs):
                let statements = DecarbonatedStatement.memCopy(result.lhsOffset, result.rhsOffset)
                label.addStatements(assignStatements)
            case .assignIntegerLiteral(let lhs, let literal):
                let statements = environment.active().literalAssignmentSemantics(lhs, literal)
                label.addStatements(statements)
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
