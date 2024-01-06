extension PILExpression {
    
    
    static var offsetCalculationCount = 0
    
    
    // TODO: Consider adding a specialized error message for when attempting to take address-of an LValue.
    // Implementation Method: Add a parameter to the function below: `addressOf: Bool`, that is used to generate a proper error message.
    
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
