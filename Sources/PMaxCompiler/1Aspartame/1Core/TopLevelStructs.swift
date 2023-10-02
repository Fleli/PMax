extension Aspartame {
    
    /// Check the global scope for `struct` declarations and use these to generate `StructType` instances.
    internal func generateTopLevelStructTypes() {
        
        structs.forEach { `struct` in
            
            let structType = StructType(`struct`)
            
            if structTypes[structType.name] != nil {
                submitError(.invalidRedeclarationOfStruct(typeName: structType.name))
                return
            }
            
            structTypes[structType.name] = structType
            
        }
        
    }
    
    /// Go through the global scope and find all `struct` declarations again. Now that they are all located and we have set them up, we complete them by finding their memory layouts.
    internal func completeTopLevelStructTypes() {
        
        structs.forEach { `struct` in
            
            guard let structType = structTypes[`struct`.name] else {
                fatalError("Struct type \(`struct`.name) should be defined.")
            }
            
            structType.generateMemoryLayoutIfMissing(self, [])
            
        }
        
    }
    
}
