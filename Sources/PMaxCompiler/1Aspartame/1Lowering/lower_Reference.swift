extension Aspartame {
    
    func lower(_ reference: Reference) -> LoweredExpression {
        
        switch reference {
            
        case .identifier(let identifier):  // identifier
            
            return .directVariable(identifier)
            
        case .intLiteral(let integer):  // integerLiteral
            
            fatalError()
            
        case .member(let reference, _, let member):  // reference.member
            
            fatalError()
            
        case .call(let functionName, _, let arguments, _):  // functionName ( Arguments )
            
            // TODO: Find out more about the required calling convention before lowering calls.
            fatalError()
            
        }
        
    }
    
}
