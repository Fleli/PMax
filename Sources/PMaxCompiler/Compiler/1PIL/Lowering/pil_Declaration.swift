extension Declaration {
    
    func lowerToPIL(_ lowerer: PILLowerer) -> [PILStatement] {
        
        let type = PILType(type, lowerer)
        let name = name
        
        let declarationSucceeded = lowerer.local.declare(type, name)
        
        guard declarationSucceeded else {
            return []
        }
        
        let pilDeclaration = PILStatement.declaration(type: type, name: name)
        
        var statements: [PILStatement] = [pilDeclaration]
        
        if let defaultValue = value {
            
            // TODO: Consider reordering and generating an intermediate variable here since default values in declarations shouldn't really be able to refer to themselves. In other words, we change the order to:
            // (1) Declare a new non-colliding variable
            // (2) Assign the default value to that new variable
            // (3) Declare the variable we're interested in (`name`)
            // (4) Assign the intermediate variable to the actual variable
            // That way, use of `name` in the default value will refer to `name` in outer scopes and can be used unambiguously.
            
            let syntacticEquivalentAssignment = Assignment(.identifier(name), defaultValue)
            let loweredAssignment = syntacticEquivalentAssignment.lowerToPIL(lowerer)
            
            statements.append(loweredAssignment)
            
        }
        
        return statements
        
    }
    
}
