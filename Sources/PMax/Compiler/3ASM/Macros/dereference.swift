extension TACStatement {
    
    func dereference(_ lhs: LValue, _ arg: RValue, _ words: Int) -> String {
        
        let basePointer = 0
        let pointer = 1
        let scratch = 2
        let tempStorage = 3
        
        // Fetch the pointer
        var assembly = load_register_with_value(arg, register: basePointer, 0)
        
        // We need to copy the whole underlying (pointed-to) object
        for i in 0 ..< words {
            
            assembly = assembly.addi(pointer, basePointer, i, "a[\(i)]")
            assembly = assembly.ldind(tempStorage, pointer, "r\(tempStorage) = a[\(i)]")
            
            assembly += assign_to_location(lhs, tempStorage, scratch, i)
            
        }
        
        // Return the generated assembly code
        return assembly
        
    }
    
}

