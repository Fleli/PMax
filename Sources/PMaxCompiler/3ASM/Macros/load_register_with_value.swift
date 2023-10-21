
extension TACStatement {
    
    
    /// Load a register with a value at a given location. Since types larger than 1 word may need extra offsets, an `extraOffset` integer is included. It is added on top of the address calculated by offsetting the stack pointer.
    func load_register_with_value(at location: Location, register index: Int, _ extraOffset: Int) -> String {
        
        guard 0 <= index  &&  index <= 7 else {
            fatalError("Register index cannot be \(index).")
        }
        
        switch location {
            
        case .framePointer(let offset):
            
            return
                calculate_stack_pointer_offset(index, offset + extraOffset)
                .ldfr(index, index, "Load the variable located at the value in r\(index)")
            
        case .dataSection(let index):
            
            return ""
            
        case .rawPointer(let offset):
            
            return ""
            
        }
        
    }
    
    
}
