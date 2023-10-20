class LiteralPool {
    
    private weak var lowerer: PILLowerer!
    
    init(_ lowerer: PILLowerer) {
        self.lowerer = lowerer
    }
    
    /// For each new literal, increment this. It is used to be certain that literal variables do not collide with programmer-declared variables.
    private var internalLiteralCounter = 0
    
    /// A dictionary where each `key: String` is an integer literal in `String` format (used directly from the corresponding token's `content`) and each `value: String` contains the variable name for that literal.
    private var integerLiterals: [String : String] = [:]
    
    /// Notify the literal pool that an integer literal was encountered. If the literal hasn't been seen yet, a new instance is created. Otherwise, the existing literal is simply reused. Also notify the `PILLowerer`'s global scope of the new literal.
    func integerLiteral(_ literal: String) -> String {
        
        if let existing = integerLiterals[literal] {
            return existing
        }
        
        let newVariable = "literal#\(internalLiteralCounter)=\(literal)"
        
        integerLiterals[literal] = newVariable
        
        let success = lowerer.global.declare(.int, newVariable)
        assert(success)
        
        internalLiteralCounter += 1
        
        return newVariable
        
    }
    
}
