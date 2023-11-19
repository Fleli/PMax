class AssemblyLowerer {
    
    
    private var tacLabels: TACLowerer.Labels
    
    
    init(_ labels: TACLowerer.Labels) {
        self.tacLabels = labels
    }
    
    
    func lower(_ compileAsLibrary: Bool) -> String {
        
        var output = ""
        
        for function in tacLabels {
            
            let name = function.key
            let labelGroup = function.value
            
            let asmString = labelGroup.all.reduce("") { $0 + $1.lowerToBreadboardAssembly() + "\n" }
            
            if compileAsLibrary {
                // TODO: We need the function's signature to make a valid library file.
                output += "[lib]\n" + asmString
            } else {
                output += asmString
            }
            
        }
        
        return output
        
    }
    
    
}
