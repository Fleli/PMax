extension Aspartame {
    
    func lower(_ reference: Reference) -> IntermediateResult {
        
        switch reference {
            
        case .identifier(let identifier):  // identifier
            
            return IntermediateResult(identifier, [])
            
        case .intLiteral(let integer):  // integerLiteral
            // For now, we just assign a variable the immediate value. Type checking/inference is done later, when actually binding names.
            // TODO: Follow this up.
            let result = newInternalVariable()
            
            let declaration = result.statement
            let assignment = AspartameStatement.assignIntegerLiteral(lhs: result.name, literal: integer)
            
            let statements = [declaration, assignment]
            
            return IntermediateResult(result.name, statements)
            
        case .member(let reference, _, let member):  // reference.member
            
            let loweredReference = lower(reference)
            
            let newVariable = newInternalVariable()
            let name = newVariable.name
            
            let declaration = newVariable.statement
            let memberAccess = AspartameStatement.accessMember(lhs: name, rhs: loweredReference.resultName, member: member)
            
            let statements = loweredReference.statements + [declaration, memberAccess]
            
            return IntermediateResult(name, statements)
            
        case .call(let functionName, _, let arguments, _):  // functionName ( Arguments )
            
            // TODO: Find out more about the required calling convention before lowering calls.
            fatalError()
            
        }
        
    }
    
}
