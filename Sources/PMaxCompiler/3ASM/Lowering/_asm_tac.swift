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
                assembly += load_register_with_value(at: rhs, register: dataRegister, i)
                assembly += assign_to_location(lhs, dataRegister, scratch, i)
            }
            
        case .assignBinaryOperation(let lhs, let operation, let arg1, let arg2):
            
            assembly = load_register_with_value(at: arg1, register: 0, 0)
            assembly += load_register_with_value(at: arg2, register: 1, 0)
            assembly += perform_arithmetic(0, 0, 1, operation)
            assembly += assign_to_location(lhs, 0, 1, 0)
            
        case .assignUnaryOperation(let lhs, let operation, let arg):
            
            assembly = load_register_with_value(at: arg, register: 0, 0)
            assembly += perform_arithmetic(0, 0, operation)
            assembly += assign_to_location(lhs, 0, 1, 0)
            
        case .call(let lhs, let functionLabel, let returnLabel, let words):
            
            assembly += perform_call(lhs, functionLabel, returnLabel, words)
            
        default:
            return ""
        }
        
        return "\n ; \(self.description)\n" + assembly
        
    }
    
    
}
