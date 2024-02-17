
extension TACStatement {
    
    
    // TODO: Double-check this one.
    
    
    /// Assign the value in register number `rhs` to the location in `lhs`. This procedure assumes that the correct value is already present in the specified register. The `assign_to_location` function also requires a `scratch` register which is used temporarily because the single `rhs` register is not sufficient. The contents of `scratch` will be overwritten.
    /// The `extraOffset` integer is used for types larger than 1 word. They may require a certain offset to be added to addresses referred to by the `lhs` location.
    func assign_to_location(_ lhs: LValue, _ rhs: Int, _ scratch: Int, _ extraOffset: Int) -> String {
        
        print("assign_to_loc = \(lhs), rhs = \(rhs), extra = \(extraOffset)")
        
        switch lhs {
        case .stackAllocated(let offset):
            return "".stio(.stackPointer, offset + extraOffset, rhs, "[fp + \(offset + extraOffset)] = r\(rhs)")
        case .dereference(let offset):
            return load_register_with_value(.stackAllocated(framePointerOffset: offset + extraOffset), register: scratch, 0).st(scratch, rhs, "[r\(scratch)] = r\(rhs)")
        }
        
    }
    
    
}
