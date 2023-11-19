class AssemblyLowerer {
    
    
    private var tacLabels: TACLowerer.Labels
    
    
    init(_ labels: TACLowerer.Labels) {
        self.tacLabels = labels
    }
    
    
    func lower(_ compileAsLibrary: Bool) -> String {
        
        var output = ""
        
        for labelGroup in tacLabels.values {
            
            let asmString = labelGroup.all.reduce("") { $0 + $1.lowerToBreadboardAssembly() + "\n" }
            
            if compileAsLibrary {
                
                let entry = labelGroup.entry.name
                let signature = labelGroup.pilFunction.signature
                
                output += buildLibraryFunction(signature, entry, asmString)
                
            } else {
                
                output += asmString
                
            }
            
        }
        
        return output
        
    }
    
    private func buildLibraryFunction(_ signature: String, _ entryLabel: String, _ assembly: String) -> String {
        
        let entryStatement = "\tLabel \(entryLabel);\n"
        let asmStatement = "\tassign asm = \"\(assembly)\";\n"
        
        let libraryFunction = signature + " {\n" + entryStatement + asmStatement + "}"
        
        return libraryFunction
        
    }
    
}
