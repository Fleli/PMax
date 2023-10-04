enum DecarbonatedStatement {
    
    case memCopy(_ lhsOffset: Int, _ rhsOffset: Int)    // Assignment:          lhs = rhs;
    case storeImm(_ lhsOffset: Int, _ imm: Int)         // Store immediate:     lhs = imm;
    
}
