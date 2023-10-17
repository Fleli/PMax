extension PILStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer, _ activeLabel: Label) {
        
        var activeLabel = activeLabel
        
        switch self {
            
        case .declaration(let type, let name):
            
            // Declarations do not add any new statements. They just inform the local scope about the variable's existence.
            lowerer.local.declare(type, name)
            
        case .assignment(let lhs, let rhs):
            break
        case .return(let expression):
            break
        case .if(let pILIfStatement):
            pILIfStatement.lowerToTAC(lowerer, activeLabel)
        case .while(let condition, let body):
            break
        }
        
        
    }
    
    
}
