extension PILExpression {
    
    
    static var offsetCalculationCount = 0
    
    
    func lowerToTACAsLHS(_ lowerer: TACLowerer) -> Location {
        
        switch value {
            
        case .variable(let variable):
            
            return lowerer.local.getVariable(variable).location
            
        case .dereference(let dereferenced):
            
            guard case .framePointer(let offset) = dereferenced.lowerToTAC(lowerer) else {
                // TODO: The assumption that this guard never fails may be incorrect. Double-check this.
                fatalError()
            }
            
            return Location.rawPointer(offset: offset)
            
        case .member(let main, let member):
            
            return lowerLHSMember(main, member, lowerer)
            
        // Avoid default cases. Explicitly state which cases submit an error.
        case .integerLiteral(_), .addressOf(_), .unary(_, _), .binary(_, _, _), .call(_):
            
            lowerer.submitError(.unassignableLHS(lhs: self))
            return .framePointer(offset: 0)
            
        }
        
    }
    
    
}
