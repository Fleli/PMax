enum DecarbonatedStatement: CustomStringConvertible {
    
    case memCopy(_ lhsOffset: Int, _ rhsOffset: Int)    // Assignment:          lhs = rhs;
    case storeImm(_ lhsOffset: Int, _ imm: Int)         // Store immediate:     lhs = imm;
    
    var description: String {
        switch self {
        case .memCopy(let lhsOffset, let rhsOffset):
            return "Memory copy \(lhsOffset) <- \(rhsOffset)"
        case .storeImm(let lhsOffset, let imm):
            return "Store immediate \(imm) at \(lhsOffset)"
        }
    }
    
}
