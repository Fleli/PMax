
extension TACStatement {
    
    
    /// Assign the value in register number `rhs` to the location in `lhs`. This procedure assumes that the correct value is already present in the specified register. The `assign_to_location` function also requires a `scratch` register which is used temporarily because the single `rhs` register is not sufficient. The contents of `scratch` will be overwritten.
    /// The `extraOffset` integer is used for types larger than 1 word. They may require a certain offset to be added to addresses referred to by the `lhs` location.
    func assign_to_location(_ lhs: Location, _ rhs: Int, _ scratch: Int, _ extraOffset: Int) -> String {
        
        switch lhs {
        case .framePointer(let offset):
            
            return "".stio(.stackPointer, offset + extraOffset, rhs, "[fp + \(offset + extraOffset)] = r\(rhs)")
            
        case .literalValue(_):
            
            // Unreachable: Assignments to literals are caught when trying to lower to TAC.
            fatalError()
            
        case .rawPointer(let rawPointerValue):
            
            let rhsAddress: Location
            
            switch rawPointerValue {
                
            case .literal(let literal):
                rhsAddress = .literalValue(value: literal)
            case .framePointerOffset(let offset):
                rhsAddress = .framePointer(offset: offset)
            }
            
            let assembly = load_register_with_value(at: rhsAddress, register: scratch, 0).st(scratch, rhs, "[r\(scratch)] = r\(rhs)")
            
            return assembly
            
        }
        
    }
    
    
}
