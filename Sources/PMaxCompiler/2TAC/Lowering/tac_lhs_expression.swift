extension PILExpression {
    
    
    static var offsetCalculationCount = 0
    
    
    func lowerToTACAsLHS(_ lowerer: TACLowerer) -> Location {
        
        
        switch value {
            
        case .variable(let variable):
            
            return lowerer.local.getVariable(variable).location
            
        case .dereference(let dereferenced):
            
            guard case .framePointer(let offset) = dereferenced.lowerToTAC(lowerer) else {
                // TODO: The assumption that this guard never fails may not be right. Double-check this.
                fatalError()
            }
            
            return Location.rawPointer(offset: offset)
            
        case .member(let main, let member):
            
            return self.lowerLHSMember(main, member, lowerer)
            
        default:
            
            lowerer.submitError(.unassignableLHS(lhs: self))
            return .framePointer(offset: 0)
            
        }
        
    }
    
    
}
