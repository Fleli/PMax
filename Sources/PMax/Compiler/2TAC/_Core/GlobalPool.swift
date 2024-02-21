
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
    
    /// Build the assembly code that corresponds to the constant values held by this `GlobalPool` instance.
    func buildDataSegment() -> String {
        
        // If there are no globals, don't bother
        if globals.count == 0 {
            return ""
        }
        
        
        var dataSegment = ".DATA {"
        
        let sortedGlobals = globals.sorted { $0.value < $1.value }
        
        for pair in sortedGlobals {
            for word in pair.key.storedWords() {
                dataSegment += "\n\t\(word)"
            }
        }
        
        dataSegment += "\n}\n\n"
        
        return dataSegment
        
    }
    
    
}
