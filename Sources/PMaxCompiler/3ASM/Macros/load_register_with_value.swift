extension TACStatement {
    
    func load_register_with_value(at location: Location, register index: Int) -> String {
        
        guard 0 <= index  &&  index <= 7 else {
            fatalError("Register index cannot be \(index).")
        }
        
        switch location {
            
        case .framePointer(let offset):
            
            return ""
                .ld(index, Self.stackPointerAddress, "Move value of stack pointer to r\(index)")
                .addi(index, index, offset, "Find the exact address of the local variable.")
                .ldfr(index, index, "Load the variable located at the value in r\(index)")
            
        case .dataSection(let index):
            
            return ""
            
        case .rawPointer(let offset):
            
            return ""
            
        }
        
    }
    
    
    
    
    
    
}
