extension TACStatement {
    
    
    func perform_arithmetic(_ dst: Int, _ srcA: Int, _ srcB: Int, _ scratch: Int, _ operation: Binary) -> String {
        
        switch operation.rawValue {
            
        case "+":
            
            return "".add(dst, srcA, srcB, "Addition: r\(dst) = r\(srcA) + r\(srcB)")
            
        case "-":
            
            return "".sub(dst, srcA, srcB, "Subtraction: r\(dst) = r\(srcA) - r\(srcB)")
            
        case "<":
            
            //      a < b
            // eq.  a - b < 0
            // eq.  (a - b) & (0b1000_0000_0000_0000) != 0  for 16-bit a, b
            
            // Store a - b in dst.
            // Load scratch with 0b1000_0000_0000_0000
            // Put AND of (a-b) and 0b1000_0000_0000_0000 in dst
            
            return ""
                .sub(dst, srcA, srcB, "Subtraction: r\(dst) = r\(srcA) - r\(srcB)")
                .li(scratch, 0b1000_0000_0000_0000, "Load immediate: r\(scratch) = 0b1000_0000_0000_0000")
                .and(dst, dst, scratch, "r\(dst) != 0 if and only if r\(srcA) < r\(srcB)")
            
        case ">":
            
            // a > b is equivalent to b < a
            return perform_arithmetic(dst, srcB, srcA, scratch, Binary(rawValue: "<")!)
            
        case "<=":
            
            // The result of a > b is either 0b1000_0000_0000_0000 (if a > b), or 0 (if a <= b).
            let aGreaterThanB = perform_arithmetic(dst, srcA, srcB, scratch, Binary(rawValue: ">")!)
            
            // We now add 0b1000_0000_0000_0000.
            // The result will be 0 (due to overflow) if a > b.
            // The result will be 0b1000_0000_0000_0000 if a <= b.
            
            return aGreaterThanB
                .addi(dst, dst, 0b1000_0000_0000_0000, "Flip the boolean value of previous calculation of r\(srcA) < r\(srcB)")
            
        case ">=":
            
            // a >= b is equivalent to b <= a.
            return perform_arithmetic(dst, srcB, srcA, scratch, Binary(rawValue: "<=")!)
            
        default:
            
            // TODO: Handle this better
            return ""
            
        }
        
    }
    
    
    func perform_arithmetic(_ dst: Int, _ src: Int, _ operation: Unary) -> String {
        
        switch operation.rawValue {
            
        case "~":
            
            return "".not(dst, src, "Not (bitwise invert): r\(dst) = ~r\(src)")
            
        case "-":
            
            return "".neg(dst, src, "Negate: r\(dst) = -r\(src)")
            
        case "<<":
            
            return "".add(dst, src, src, "r\(dst) = r\(src) << 1")
            
        case ">>":
            
            return "".sr(dst, src, "r\(dst) = r\(src) >> 1")
            
        default:
            
            // TODO: Handle this better
            fatalError()
            
        }
        
    }
    
    
}
