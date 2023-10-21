extension TACStatement {
    
    
    func lowerToBreadboardAssembly() -> String {
        
        var assembly = ""
        
        switch self {
        case .jump(let label):
            
            assembly = assembly.build("j \(label)", "Unconditional jump to \(label)")
            
        case .assign(let lhs, let rhs, let words):
            
            let scratch = 1
            let dataRegister = 0
            
            // For data types larger than 1 word, we need to move multiple consecutive words in memory.
            for i in 0 ..< words {
                
                // First, we load the `dataRegister` with the value of the right-hand side.
                assembly = load_register_with_value(at: rhs, register: dataRegister, i)
                
                // Then, we store that value at the location specified by the left-hand side.
                assembly += assign_to_location(lhs, dataRegister, scratch, i)
                
            }
            
        default:
            return ""
        }
        
        return assembly
        
    }
    
    
}
