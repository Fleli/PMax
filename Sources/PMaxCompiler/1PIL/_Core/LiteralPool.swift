class LiteralPool {
    
    /// For each new literal, increment this. It is used to be certain that literal variables do not collide with programmer-declared variables.
    private var internalLiteralCounter = 0
    
    /// A dictionary where each `key: String` is an integer literal in `String` format (used directly from the corresponding token's `content`) and each `value: String` contains the variable name for that literal.
    private var integerLiterals: [String : String] = [:]
    
    /// Notify the literal pool that an integer literal was encountered. If the literal hasn't been seen yet, a new instance is created. Otherwise, the ecisting literal is simply reused.
    func integerLiteral(_ literal: String) -> String {
        
        if let existing = integerLiterals[literal] {
            return existing
        }
        
        internalLiteralCounter += 1
        
        let newVariable = "$literal#\(internalLiteralCounter)"
        
        integerLiterals[literal] = newVariable
        
        return newVariable
        
    }
    
}