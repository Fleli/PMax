
typealias Unary = Expression.SingleArgumentOperator

class PILUnaryOperator {
    
    let arg: String
    
    let type: PILType
    
    let signature: PILUnaryOperatorSignature
    
    let macroReplacement: PILExpression
    
    init(_ underlyingUnaryOperatorDeclaration: UnaryOperator, _ lowerer: PILLowerer) {
        
        self.arg = underlyingUnaryOperatorDeclaration.arg
        
        self.type = PILType(.basic(underlyingUnaryOperatorDeclaration.arg), lowerer)
        
        self.signature = .init(
            PILType(.basic(underlyingUnaryOperatorDeclaration.arg), lowerer),
            Unary(rawValue: underlyingUnaryOperatorDeclaration.operator.description)!
        )
        
        self.macroReplacement = underlyingUnaryOperatorDeclaration.replacement.lowerToPIL(lowerer)
        
    }
    
}

struct PILUnaryOperatorSignature: Hashable {
    
    let argType: PILType
    let `operator`: Unary
    
    init(_ argType: PILType, _ `operator`: Unary) {
        self.argType = argType
        self.`operator` = `operator`
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(argType)
    }
    
}
