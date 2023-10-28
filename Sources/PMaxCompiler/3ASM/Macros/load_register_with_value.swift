
extension TACStatement {
    
    
    /// Load a register with a value at a given location. Since types larger than 1 word may need extra offsets, an `extraOffset` integer is included. It is added on top of the address calculated by offsetting the stack pointer.
    func load_register_with_value(at location: Location, register index: Int, _ extraOffset: Int) -> String {
        
        guard 0 <= index  &&  index <= 7 else {
            fatalError("Register index cannot be \(index).")
        }
        
        switch location {
            
        case .framePointer(let offset):
            
            // .addi(destination, .stackPointer, offset, "Find the address of the variable located \(offset) from the stack pointer")
            // .ldfr(index, index, "Load the variable located at the value in r\(index)")
            
            
            
            return "".ldio(index, .stackPointer, offset, "r\(index) = [fp + \(offset)] @@")
            
        case .dataSection(let index):
            
            return
                calculate_data_offset(index, index + extraOffset)
                .ldfr(index, index, "Load the variable in the data section pointed to by r\(index)")
            
        case .rawPointer(_):
            
            // TODO: Not implemented
            fatalError()
            
        }
        
    }
    
    
}
