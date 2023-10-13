
typealias Infix = Expression.InfixOperator

class PILBinaryOperator {
    
    let lhs: String
    let rhs: String
    
    let type: PILType
    
    let signature: PILBinaryOperatorSignature
    
    let macroReplacement: PILExpression
    
    init(_ underlyingBinaryOperatorDeclaration: BinaryOperator, _ lowerer: PILLowerer) {
        
        self.lhs = underlyingBinaryOperatorDeclaration.lhs
        self.rhs = underlyingBinaryOperatorDeclaration.rhs
        
        self.type = PILType(.basic(underlyingBinaryOperatorDeclaration.type), lowerer)
        
        self.signature = .init(
            PILType(.basic(underlyingBinaryOperatorDeclaration.lhsType), lowerer),
            PILType(.basic(underlyingBinaryOperatorDeclaration.rhsType), lowerer),
            Infix(rawValue: underlyingBinaryOperatorDeclaration.operator.description)!
        )
        
        self.macroReplacement = underlyingBinaryOperatorDeclaration.replacement.lowerToPIL(lowerer)
        
    }
    
}

struct PILBinaryOperatorSignature: Hashable {
    
    let lhsType: PILType
    let rhsType: PILType
    let `operator`: Infix
    
    init(_ lhsType: PILType, _ rhsType: PILType, _ `operator`: Infix) {
        self.lhsType = lhsType
        self.rhsType = rhsType
        self.`operator` = `operator`
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(lhsType)
        hasher.combine(rhsType)
    }
    
}
