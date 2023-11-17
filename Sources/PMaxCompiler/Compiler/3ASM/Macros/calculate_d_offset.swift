extension TACStatement {
    
    
    /// Load the data segment pointer and perform an addition between it and the given `offset`. Store the sum in the `destination` register.
    /// This stores `d + offset`, NOT `[d + offset]` in `destination`. In other words, the result is an _address_, not a _value_.
    func calculate_data_offset(_ destination: Int, _ offset: Int) -> String {
        
        return ""
            .ldraw(destination, Self.dataSectionAddress, "Load the data section pointer")
            .addi(destination, destination, offset, "Calculate the offset address")
        
    }
    
    
}
