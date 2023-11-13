class LiteralPool {
    
    private weak var lowerer: PILLowerer!
    
    init(_ lowerer: PILLowerer) {
        self.lowerer = lowerer
    }
    
    /// A dictionary where each `key: String` is an integer literal in `String` format (used directly from the corresponding token's `content`) and each `value: String` contains the variable name for that literal.
    private var integerLiterals: [String : String] = [:]
    
    /// A dictionary where each `key: String` is a string literal and each `value: String` contains the variable name for that literal.
    private var stringLiterals: [String : String] = [:]
    
    /// A dictionary where each `key: String` is a char literal and each `value: String` contains the variable name for that literal.
    private var charLiterals: [String : String] = [:]
    
    func integerLiteral(_ literal: String) -> String {
        return sharedLiteralGenerator(literal, .int, &integerLiterals)
    }
    
    func stringLiteral(_ literal: String) -> String {
        return sharedLiteralGenerator(literal + "\0", .char, &stringLiterals)
    }
    
    func charLiteral(_ literal: String) -> String {
        return sharedLiteralGenerator(literal, .char, &charLiterals)
    }
    
    /// Notify the literal pool that a literal was encountered. If the literal hasn't been seen yet, a new instance is created. Otherwise, the existing literal is simply reused. Also notify the `PILLowerer`'s global scope of the new literal.
    private func sharedLiteralGenerator(_ literal: String, _ type: PILType, _ pool: inout [String : String]) -> String {
        
        if let existing = pool[literal] {
            return existing
        }
        
        let newVariable = "literal=\(literal)"
        
        pool[literal] = newVariable
        
        lowerer.global.declare(type, newVariable)
        
        return newVariable
        
    }
    
}
