extension TACStatement {
    
    
    func perform_arithmetic(_ dst: Int, _ srcA: Int, _ srcB: Int, _ operation: Binary) -> String {
        
        switch operation.rawValue {
            
        case "+":
            return "".add(dst, srcA, srcB, "Addition: r\(dst) = r\(srcA) + r\(srcB)")
        case "-":
            return "".sub(dst, srcA, srcB, "Subtraction: r\(dst) = r\(srcA) - r\(srcB)")
        default:
            break
            
        }
        
        return ""
        
    }
    
    
}
