extension PILStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer) {
        
        switch self {
            
        case .declaration(let type, let name):
            
            // Declarations do not add any new statements. They just inform the local scope about the variable's existence.
            lowerer.local.declare(type, name)
            
        case .assignment(let lhs, let rhs):
            
            break
            
        case .return(let expression):
            
            let value = expression?.lowerToTAC(lowerer)
            
            let statement = TACStatement.return(value: value)
            lowerer.activeLabel.newStatement(statement)
            
        case .if(let pILIfStatement):
            
            let continueLabel = Label("if:next")
            pILIfStatement.lowerToTAC(lowerer, continueLabel)
            
        case .while(let condition, let body):
            
            break
            
        }
        
        
    }
    
    
}
