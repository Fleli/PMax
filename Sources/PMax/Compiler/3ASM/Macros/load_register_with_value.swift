
extension TACStatement {
    
    
    /// Load a register with a value at a given location. Since types larger than 1 word may need extra offsets, an `extraOffset` integer is included. It is added on top of the address calculated by offsetting the stack pointer.
    func load_register_with_value(_ value: RValue, register index: Int, _ extraOffset: Int) -> String {
        
        guard 0 <= index  &&  index <= 7 else {
            fatalError("Register index cannot be \(index).")
        }
        
        print("load_reg_with_val = \(value), reg = \(index), extra = \(extraOffset)")
        
        switch value {
            
        case .stackAllocated(let offset):
            
            return "".ldio(index, .stackPointer, offset + extraOffset, "r\(index) = [fp + \(offset + extraOffset)]")
            
        case .integerLiteral(let value):
            
            return "".li(index, value, "r\(index) = \(value)")
            
        case .dereference(let framePointerOffset):
            
            // TODO: Apparently unreachable. Double-check this.
            fatalError("deref @ load_register_with_value: fpOffset = \(framePointerOffset)")
            
        }
        
    }
    
    
}
