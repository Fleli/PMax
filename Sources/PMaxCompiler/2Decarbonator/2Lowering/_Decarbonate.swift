extension FunctionLabel {
    
    func decarbonate(_ decarbonator: Decarbonator) {
        
        let environment: Environment = decarbonator.environment
        
        var label = environment.label(name)
        
        for statement in loweredBody {
            
            switch statement {
            case .declaration(let name, let type):
                environment.active().declareSemantics(name, type)
            case .assignment(let lhs, let rhs):
                let statements = environment.active().assignmentSemantics(lhs, rhs)
                label.addStatements(statements)
            case .assignIntegerLiteral(let lhs, let literal):
                let statements = environment.active().literalAssignmentSemantics(lhs, literal)
                label.addStatements(statements)
            case .accessMember(let lhs, let rhs, let member):
                let statements = environment.active().accessMemberSemantics(lhs, rhs, member)
                label.addStatements(statements)
            case .assignFromCall(let lhs, let function, let arguments):
                break
            case .block(let statements):
                break
            case .ignoreNextIfZero(let check, let n):
                break
            case .jumpBack(let n):
                break
            case .return(let value):
                break
            }
            
        }
        
    }
    
}
