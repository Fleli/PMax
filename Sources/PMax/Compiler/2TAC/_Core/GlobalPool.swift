
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
        
        // Start the data segment with `.DATA {`
        var dataSegment = ".DATA {"
        
        // Sort all globals by offset
        let sortedGlobals = globals.sorted { $0.value < $1.value }
        
        // Go through each key-value pair
        for (key, value) in sortedGlobals {
            
            // Go through each word of the key (the actual data)
            for word in key.storedWords() {
                
                // ... and add a line containing that data
                dataSegment += "\n\t\(word)"
                
            }
            
        }
        
        // End the data segment with some newlines and `}`
        dataSegment += "\n}\n\n"
        
        return dataSegment
        
    }
    
    
}
