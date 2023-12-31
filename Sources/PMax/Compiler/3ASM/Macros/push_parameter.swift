extension TACStatement {
    
    
    func push_parameter(_ location: Location, _ words: Int, _ parameterOffset: Int) -> String {
        
        var assembly = ""
        
        let locationUsableForCallee = Location.framePointer(offset: parameterOffset)
        
        switch location {
        case .framePointer(let argumentOffset):
            
            for i in 0 ..< words {
                
                let calculatedArgumentLocation = Location.framePointer(offset: argumentOffset)
                
                // Load the value of the argument into register 0. Then store it so that it's accessible to the callee (using r1 as scratch register).
                assembly += self.load_register_with_value(at: calculatedArgumentLocation, register: 0, i)
                assembly += self.assign_to_location(locationUsableForCallee, 0, 1, i)
                
            }
            
        case .literalValue(let value):
            
            // Load the immediate value into r0 and store it at `locationUsableForCallee`
            // Use r1 as a scratch register.
            assembly += "".li(0, value)
            assembly += self.assign_to_location(locationUsableForCallee, 0, 1, 0)
            
        case .rawPointer(_):
            fatalError("Parameters cannot be raw pointers \(location).")
        }
        
        return assembly
        
    }
    
    
}
