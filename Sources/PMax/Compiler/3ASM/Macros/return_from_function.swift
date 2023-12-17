extension TACStatement {
    
    
    func return_from_function(_ value: Location?, _ words: Int) -> String {
        
        var assembly = ""
        
        // When we return from a function, we copy the given `value` to the data return space. We also jump to `[fp - 1]` and revert back to the old frame pointer.
        
        // If there is a value to return, we move that value to the return value data space
        if let value {
            
            let returnValueOffset = -(1 + words)      // 2 locations for the FP and ret. address, and `words` addresses since the return values itself takes up some space
            
            for i in 0 ..< words {
                
                let returnValueLocation = Location.framePointer(offset: returnValueOffset)
                
                assembly += self.load_register_with_value(at: value, register: 0, i)    // Load to r0
                assembly += self.assign_to_location(returnValueLocation, 0, 1, i)       // Store r0, using r1 as scratch
                
            }
            
        }
        
        // Then, we want to jump to [fp - 1]
        
        // We start by calculating fp - 1 and then fetch the data there.
        assembly += self.calculate_stack_pointer_offset(0, -1)
        assembly = assembly.ldind(0, 0, "Fetch [fp - 1]")
        
        // Now, we have [fp - 1] in r0. Now, we want to jump (unconditionally) to it.
        assembly = assembly.j(0, "Jump to the address stored in r0.")
        
        return assembly
        
    }
    
    
}
