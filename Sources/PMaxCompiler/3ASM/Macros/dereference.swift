extension TACStatement {
    
    
    func dereference(_ lhs: Location, _ arg: Location, _ words: Int) -> String {
        
        // Say our statement is:  assign b = *a;
        
        // Register allocation
        // r0:  The value of a
        // r1:  The value a + i for each i in 0 ..< words
        // r2:  Scratch register for assignments
        
        // First, we find the value of a
        var assembly = load_register_with_value(at: arg, register: 0, 0)
        
        // For each word in *a:
        for i in 0 ..< words {
            
            // Calculate (a + i) since that is the i-th word in (*a).
            // Then, we find the value _pointed to_ by a (that is, *a)
            assembly = assembly.ldio(0, 0, i, "r0 = [r0 + \(i)]")
            
            assembly = assembly.addi(1, 0, i, "Find the offset r0 + \(i).")
            
            // Then, we assign that value to b's i-th word. The address we're assigning is stored in r1. We use r2 as an intermediate scratch register.
            assembly += assign_to_location(lhs, 1, 2, i)
            
        }
        
        return assembly
        
    }
    
    
}

