extension Aspartame {
    
    /// Pass through all function declarations at the top level. These should be accessible anywhere in the program, so they must be located _before_ any reference to them is made.
    internal func generateFunctionLabels() {
        
        functions.forEach { function in
            
            let functionName = function.name
            
            guard let functionLabel = FunctionLabel(function, self) else {
                // An error has already been submitted by the initializer in the attempt to verify the existence of types.
                return
            }
            
            if functionLabels[functionName] != nil {
                submitError(.invalidRedeclarationOfFunction(functionName: functionName))
                return
            }
            
            functionLabels[functionName] = functionLabel
            
        }
        
    }
    
}
