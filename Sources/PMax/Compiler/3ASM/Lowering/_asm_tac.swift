extension TACStatement {
    
    
    func lowerToBreadboardAssembly() -> String {
        
        var assembly = ""
        
        switch self {
        case .jump(let label):
            
            assembly = assembly.build("jimm \(label)", "Unconditional jump to \(label)")
            
        case .assign(let lhs, let rhs, let words):
            
            let scratch = 1
            let dataRegister = 0
            
            // For data types larger than 1 word, we need to move multiple consecutive words in memory.
            for i in 0 ..< words {
                assembly += load_register_with_value(rhs, register: dataRegister, i)
                assembly += assign_to_location(lhs, dataRegister, scratch, i)
            }
            
        case .assignBinaryOperation(let lhs, let operation, let arg1, let arg2):
            
            assembly = load_register_with_value(arg1, register: 0, 0)
            assembly += load_register_with_value(arg2, register: 1, 0)
            assembly += perform_arithmetic(0, 0, 1, 2, operation)
            assembly += assign_to_location(lhs, 0, 1, 0)
            
        case .assignUnaryOperation(let lhs, let operation, let arg):
            
            assembly = load_register_with_value(arg, register: 0, 0)
            assembly += perform_arithmetic(0, 0, operation)
            assembly += assign_to_location(lhs, 0, 1, 0)
            
        case .call(let lhs, let functionLabel, let returnLabel, let words):
            
            assembly += perform_call(lhs, functionLabel, returnLabel, words)
            
        case .pushParameter(let location, let words, let parameterOffset):
            
            assembly += push_parameter(location, words, parameterOffset)
            
        case .return(let value, let words):
            
            let rvalue = (value == nil) ? nil : RValue.stackAllocated(framePointerOffset: value!)
            
            assembly += return_from_function(rvalue, words)
            
        case .addressOf(let lhs, let arg):
            
            assembly += address_of(lhs, arg)
            
        case .jumpIfNonZero(let label, let variable):
            
            assembly += load_register_with_value(variable, register: 0, 0)
                .jnz(0, label, "Jump to \(label) if r0 != 0")
            
        case .dereference(let lhs, let arg, let words):
            
            assembly += dereference(lhs, arg, words)
            
        }
        
        return (String.includeCommentsInAssembly ? "\n; \(self.description)\n" : "") + assembly
        
    }
    
    
}
