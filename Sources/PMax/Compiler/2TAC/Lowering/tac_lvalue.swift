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
            
        case .integerLiteral(_), .stringLiteral(_), .addressOf(_), .unary(_, _), .binary(_, _, _), .call(_), .sizeof(_):
            
            lowerer.submitError(PMaxIssue.unassignableLHS(lhs: self))
            return .stackAllocated(framePointerOffset: 0)
            
        }
        
    }
    
    
}
