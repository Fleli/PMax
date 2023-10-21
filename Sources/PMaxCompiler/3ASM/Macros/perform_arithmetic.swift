extension TACStatement {
    
    
    func perform_arithmetic(_ dst: Int, _ srcA: Int, _ srcB: Int, _ operation: Binary) -> String {
        
        switch operation.rawValue {
            
        case "+":
            
            return "".add(dst, srcA, srcB, "Addition: r\(dst) = r\(srcA) + r\(srcB)")
            
        case "-":
            
            return "".sub(dst, srcA, srcB, "Subtraction: r\(dst) = r\(srcA) - r\(srcB)")
            
        default:
            
            // TODO: Handle this better
            fatalError()
            
        }
        
    }
    
    
    func perform_arithmetic(_ dst: Int, _ src: Int, _ operation: Unary) -> String {
        
        switch operation.rawValue {
            
        case "~":
            
            return "".not(dst, src, "Not (bitwise invert): r\(dst) = ~r\(src)")
            
        case "-":
            
            return "".neg(dst, src, "Negate: r\(dst) = -r\(src)")
            
        default:
            
            // TODO: Handle this better
            fatalError()
            
        }
        
    }
    
    
}
