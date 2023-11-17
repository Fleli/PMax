extension TACStatement {
    
    func address_of(_ lhs: Location, _ arg: Location) -> String {
        
        var assembly: String
        
        switch arg {
        case .framePointer(let offset):
            
            // Adressen til variabelen er sp + offset
            assembly = calculate_stack_pointer_offset(0, offset)
            
        case .literalValue(_):
            
            // TODO: This is definitely reachable: &6. Catch this (and submit an error) earlier so that assembly code generation is safe.
            fatalError()
            
        case .rawPointer(_):
            
            // Not reachable
            fatalError()
            
        }
        
        assembly += assign_to_location(lhs, 0, 1, 0)
        
        return assembly
        
    }
    
}
