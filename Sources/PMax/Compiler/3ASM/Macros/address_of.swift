extension TACStatement {
    
    func address_of(_ lhs: LValue, _ arg: LValue) -> String {
        
        var assembly: String
        
        switch arg {
        case .stackAllocated(let offset):
            assembly = calculate_stack_pointer_offset(0, offset)
        case .dereference(let framePointerOffset):
            // TODO: Is this legal?
            /// Looks like `&*x;*`
            fatalError("\(framePointerOffset)")
        }
        
        assembly += assign_to_location(lhs, 0, 1, 0)
        
        return assembly
        
    }
    
}
