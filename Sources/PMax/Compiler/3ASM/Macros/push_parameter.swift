extension TACStatement {
    
    
    func push_parameter(_ value: RValue, _ words: Int, _ parameterOffset: Int) -> String {
        
        var assembly = ""
        
        // TODO: Go over this and write comments.
        
        let availableForCallee = RValue.stackAllocated(framePointerOffset: parameterOffset)
        
        switch value {
            
        case .stackAllocated(let framePointerOffset):
            
            // If the parameter we're pushing is stack allocated, we copy each word of it into the addresses available for the called function (callee)
            for i in 0 ..< words {
                
                let calculatedArgumentLocation = RValue.stackAllocated(framePointerOffset: framePointerOffset)
                
                // Load the value of the argument into register 0. Then store it so that it's accessible to the callee (using r1 as scratch register).
                assembly += self.load_register_with_value(calculatedArgumentLocation, register: 0, i)
                assembly += self.assign_to_location(availableForCallee.treatAsLValue(), 0, 1, i)
                
            }
            
        case .integerLiteral(let value):
            
            // Load the immediate value into r0 and store it at `locationUsableForCallee`
            // Use r1 as a scratch register.
            assembly += "".li(0, value)
            assembly += self.assign_to_location(availableForCallee.treatAsLValue(), 0, 1, 0)
            
        case .dereference(let offset):
            
            // TODO: Go over this.
            fatalError("Parameters are never raw pointers. \(offset).")
            
        }
        
        return assembly
        
    }
    
    
}
