extension FunctionBodyStatement {
    
    func lowerToPIL(_ lowerer: PILLowerer) {
        
        switch self {
        case .declaration(let declaration):
            let type = PILType(declaration.type, lowerer)
            let pilDeclaration = PILStatement.declaration(type: type, name: declaration.name)
            // TODO: Add assignment
        case .assignment(let assignment):
            break
        case .return(let `return`):
            break
        case .if(let `if`):
            break
        case .while(let `while`):
            break
        }
        
    }
    
}
