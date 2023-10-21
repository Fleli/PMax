extension TACStatement {
    
    
    func lowerToBreadboardAssembly() -> String {
        
        var assembly = ""
        
        switch self {
        case .jump(let label):
            
            assembly = assembly.build("j \(label)", "Unconditional jump to \(label)")
            
        case .assign(let lhs, let rhs, let words):
            
            assembly = load_register_with_value(at: rhs, register: 0)
            
        default:
            return ""
        }
        
        return assembly
        
    }
    
    
}
