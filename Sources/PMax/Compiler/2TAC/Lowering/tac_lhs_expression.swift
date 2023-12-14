extension PILExpression {
    
    
    static var offsetCalculationCount = 0
    
    
    func lowerToTACAsLHS(_ lowerer: TACLowerer, _ function: PILFunction) -> Location {
        
        switch value {
            
        case .variable(let variable):
            
            return lowerer.local.getVariable(variable).location
            
        case .dereference(let dereferenced):
            
            let loweredDereference = dereferenced.lowerToTAC(lowerer, function)
            
            let rawPointerValue: RawPointerValue
            
            switch loweredDereference {
            case .framePointer(let offset):
                rawPointerValue = .framePointerOffset(offset)
            case .literalValue(let value):
                rawPointerValue = .literal(value)
            case .rawPointer(_):
                // TODO: Verify unreachable.
                fatalError()
            }
            
            return Location.rawPointer(rawPointerValue)
            
        case .member(let main, let member):
            
            return lowerLHSMember(main, member, lowerer, function)
            
        // Avoid default cases. Explicitly state which cases submit an error.
        case .integerLiteral(_), .addressOf(_), .unary(_, _), .binary(_, _, _), .call(_):
            
            lowerer.submitError(.unassignableLHS(lhs: self))
            return .framePointer(offset: 0)
            
        }
        
    }
    
    
}
