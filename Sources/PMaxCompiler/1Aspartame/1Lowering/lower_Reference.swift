extension Aspartame {
    
    func lower(_ reference: Reference) -> IntermediateResult {
        
        switch reference {
        case .identifier(let identifier):  // identifier
            return IntermediateResult(resultName: identifier, statements: [])
        case .intLiteral(let integer):  // integerLiteral
            // For now, we just assign a variable the immediate value. Type checking/inference is done later, when actually binding names.
            // TODO: Follow this up.
            let declaration = self.newInternalVariable(<#T##type: DataType##DataType#>)
        case .member(let reference, _, let member):  // reference.member
            <#code#>
        case .call(let functionName, _, let arguments, _):  // functionName ( Arguments )
            <#code#>
        }
        
        return .init(resultName: "", statements: [])
        
    }
    
}
