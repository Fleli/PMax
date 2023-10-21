extension TACStatement {
    
    
    /// Load the stack pointer and perform an addition between it and the given `offset`. Store the sum in the `destination` register.
    /// This stores `sp + offset`, NOT `[sp + offset]` in `destination`. In other words, the result is an _address_, not a _value_.
    func calculate_stack_pointer_offset(_ destination: Int, _ offset: Int) -> String {
        
        return ""
            .addi(destination, .stackPointer, offset, "Find the address of the variable located \(offset) from the stack pointer")
        
    }
    
    
}
