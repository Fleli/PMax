extension Aspartame {
    
    /// Check the global scope for `struct` declarations and use these to generate `StructType` instances.
    internal func generateTopLevelStructTypes(_ program: TopLevelStatements) {
        
        for statement in program {
            
            if case .struct(let `struct`) = statement {
                
                let structType = StructType(`struct`)
                
                if structTypes[structType.name] != nil {
                    // TODO: Generate an error ...
                    continue
                }
                
                structTypes[structType.name] = structType
                
            }
            
        }
        
    }
    
}
