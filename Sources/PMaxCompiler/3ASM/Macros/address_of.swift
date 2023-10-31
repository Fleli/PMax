extension TACStatement {
    
    func address_of(_ lhs: Location, _ arg: Location) -> String {
        
        var assembly: String
        
        switch arg {
        case .framePointer(let offset):
            
            // Adressen til variabelen er sp + offset
            assembly = calculate_stack_pointer_offset(0, offset)
            
        case .dataSection(_):
            
            // TODO: &literal is not allowed.
            // TODO: Consider actually allowing this (_could_ be useful for debugging in certain cases), but submitting a warning (not an issue).
            fatalError()
            
        case .rawPointer(_):
            
            // TODO: Not implemented
            fatalError()
            
        }
        
        assembly += assign_to_location(lhs, 0, 1, 0)
        
        return assembly
        
    }
    
}
