
extension TACStatement {
    
    
    /// Assign the value in register number `rhs` to the location in `lhs`. This procedure assumes that the correct value is already present in the specified register. The `assign_to_location` function also requires a `scratch` register which is used temporarily because the single `rhs` register is not sufficient. The contents of `scratch` will be overwritten.
    /// The `extraOffset` integer is used for types larger than 1 word. They may require a certain offset to be added to addresses referred to by the `lhs` location.
    func assign_to_location(_ lhs: Location, _ rhs: Int, _ scratch: Int, _ extraOffset: Int) -> String {
        
        switch lhs {
        case .framePointer(let offset):
            
            return
                calculate_stack_pointer_offset(scratch, offset + extraOffset)
                .st(scratch, rhs, "Store the value in r\(rhs) at the address in r\(scratch)")
            
        case .dataSection(let index):
            
            // Should never assign to anything in the data section.
            fatalError("\(lhs), \(index)")
            
        case .rawPointer(let offset):
            
            let varContainingAddress = Location.framePointer(offset: offset)
            
            return
            
            // Fetch the address we are going to store `rhs` at. This value is stored at a certain offset from our frame pointer.
                load_register_with_value(at: varContainingAddress, register: scratch, 0)
                
            // Then, store `rhs` at the value that is in `scratch` (which we use as an address).
                .st(scratch, rhs, "Store the value in r\(rhs) at the address in r\(scratch)")
            
        }
        
    }
    
    
}
