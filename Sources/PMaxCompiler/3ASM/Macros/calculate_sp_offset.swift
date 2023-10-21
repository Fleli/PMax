extension TACStatement {
    
    
    /// Load the stack pointer and perform an addition between it and the given `offset`. Store the sum in the `destination` register.
    func calculate_stack_pointer_offset(_ destination: Int, _ offset: Int) -> String {
        
        return ""
            .ld(destination, Self.stackPointerAddress, "Load the stack pointer")
            .addi(destination, destination, offset, "Calculate the offset address")
        
    }
    
    
}
