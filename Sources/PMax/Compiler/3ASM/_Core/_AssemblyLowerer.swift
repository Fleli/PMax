class AssemblyLowerer {
    
    
    private let lowerer: TACLowerer
    
    private var labels: TACLowerer.Labels
    
    
    init(_ lowerer: TACLowerer) {
        self.lowerer = lowerer
        self.labels = lowerer.labels
    }
    
    
    func lower(_ compileAsLibrary: Bool) -> String {
        
        var output = ""
        
        if compileAsLibrary {
            lowerAsLibrary(&output)
        } else {
            lowerAsExecutable(&output)
        }
        
        return output
        
    }
    
    
    private func lowerAsLibrary(_ output: inout String) {
        
        for pilStruct in lowerer.structs.values {
            output += pilStruct.description + "\n\n"
        }
        
        for labelGroup in labels.values {
            
            let asmString = labelGroup.all.reduce("") { $0 + $1.lowerToBreadboardAssembly() + "\n" }
            
            let entry = labelGroup.entry.name
            let signature = labelGroup.pilFunction.signature
            
            output += buildLibraryFunction(signature, entry, asmString)
            
        }
        
    }
    
    
    private func lowerAsExecutable(_ output: inout String) {
        
        for labelGroup in labels.values {
            
            for label in labelGroup.all {
                output += label.lowerToBreadboardAssembly() + "\n"
            }
            
        }
        
    }
    
    
    private func buildLibraryFunction(_ signature: String, _ entryLabel: String, _ assembly: String) -> String {
        
        let entryStatement = "\tLabel \(entryLabel);\n"
        let asmStatement = "\tassign asm = \"\(assembly)\";\n"
        
        let libraryFunction = signature + " {\n" + entryStatement + asmStatement + "}\n\n"
        
        return libraryFunction
        
    }
    
}
