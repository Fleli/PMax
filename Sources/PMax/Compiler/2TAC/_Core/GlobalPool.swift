
class GlobalPool {
    
    /// The current offset from the global pool's root
    private var currentGlobalConstantOffset: Int
    
    /// Maps a global constant to the `Int` offset where it's declared (relative to the global pool's root).
    private var globals: [GlobalConstant : Int]
    
    /// Initialize an empty GlobalPool instance.
    init() {
        self.globals = [:]
        self.currentGlobalConstantOffset = 0
    }
    
    /// Get a string as an RValue. Declare the string if it's not seen yet, or return an existing instance of it if it's already declared.
    func getStringLiteralOffsetInGlobalPool(_ literal: String) -> Int {
        
        // Create a `GlobalConstant` instance from the string literal.
        let stringLiteralGlobalConstant = GlobalConstant.stringLiteral(literal)
        
        // If the string already exists, return that old reference.
        if let existingOffset = globals[stringLiteralGlobalConstant] {
            return existingOffset
        }
        
        // The new string's global offset
        let newStringOffset = currentGlobalConstantOffset
        
        // Declare the string in the global pool.
        globals[stringLiteralGlobalConstant] = newStringOffset
        
        // Make space for the string, plus the null character to terminate it.
        currentGlobalConstantOffset += literal.count + 1
        
        // Return the offset of the newly declared string.
        return newStringOffset
        
    }
    
    
}
