
extension TACStatement {
    
    
    /// Assign the value in register number `rhs` to the location in `lhs`. This procedure assumes that the correct value is already present in the specified register. The `assign_to_location` function also requires a `scratch` register which is used temporarily because the single `rhs` register is not sufficient. The contents of `scratch` will be overwritten.
    func assign_to_location(_ lhs: Location, _ rhs: Int, _ scratch: Int) -> String {
        
        switch lhs {
        case .framePointer(let offset):
            
            return
                calculate_stack_pointer_offset(scratch, offset)
                .st(scratch, rhs, "Store the value in r\(rhs) at the address in r\(scratch)")
            
        case .dataSection(let index):
            
            // Should never assign to anything in the data section.
            fatalError("\(lhs), \(index)")
            
        case .rawPointer(let offset):
            
            return ""
            
        }
        
    }
    
    
}
