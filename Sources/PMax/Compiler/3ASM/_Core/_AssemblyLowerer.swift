class AssemblyLowerer {
    
    
    private let lowerer: TACLowerer
    
    private var labels: [String : TACLowerer.AssociatedFunctionData]
    
    
    init(_ lowerer: TACLowerer) {
        
        self.lowerer = lowerer
        self.labels = lowerer.labels
        
    }
    
    
    func lower(_ compileAsLibrary: Bool) -> String {
        
        var output = ""
        
        insertDataSegment(&output)
        
        if compileAsLibrary {
            // TODO: Check that transitive imports are handled correctly.
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
        
        output += "@__main:\n\(String.includeCommentsInAssembly ? "\t; Jump to main entry point\n" : "")\tjimm @fn_main\n\n"
        
        for labelGroup in labels.values where !labelGroup.imported {
            
            for label in labelGroup.all {
                output += label.lowerToBreadboardAssembly() + "\n"
            }
            
        }
        
    }
    
    
    private func buildLibraryFunction(_ signature: String, _ entryLabel: String, _ assembly: String) -> String {
        
        let entryStatement = "\tvar entry: Label = \"\(entryLabel)\";\n"
        let asmStatement = "\tvar asm: Code = \"\(assembly)\";\n"
        
        let libraryFunction = signature + " {\n" + entryStatement + asmStatement + "}\n\n"
        
        return libraryFunction
        
    }
    
    private func insertDataSegment(_ output: inout String) {
        
        // Request the full data segment, converted to a string, from the TACLowerer's GlobalPool instance.
        output += lowerer.globalPool.buildDataSegment()
        
    }
    
}
