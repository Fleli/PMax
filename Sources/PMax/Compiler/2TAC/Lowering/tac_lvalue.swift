extension PILExpression {
    
    
    static var offsetCalculationCount = 0
    
    
    func lowerToTACAsLValue(_ lowerer: TACLowerer, _ function: PILFunction) -> LValue {
        
        switch value {
            
        case .variable(let name):
            
            return lowerer.local.getVariableAsLValue(name)
            
        case .dereference(let expression):
            
            let dereferencedExpressionOffset = expression.lowerToTACAsStackAllocatedRValue(lowerer, function)
            
            return .dereference(framePointerOffset: dereferencedExpressionOffset)
            
        case .member(let main, let member):
            
            return lowerToTACAsMemberLValue(main, member, lowerer, function)
            
        // TODO: Produce specialized error messages for each case.
        // Avoid default cases. Explicitly state which cases submit an error.
        case .integerLiteral(_), .addressOf(_), .unary(_, _), .binary(_, _, _), .call(_):
            
            lowerer.submitError(.unassignableLHS(lhs: self))
            return .stackAllocated(framePointerOffset: 0)
            
        }
        
    }
    
    
}
