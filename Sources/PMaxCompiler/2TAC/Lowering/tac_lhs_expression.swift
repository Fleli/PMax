extension PILExpression {
    
    
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
            
            break
            
        default:
            
            // TODO: Remove this fatal error and submit an error instead.
            // Only dereferences, members and variables are assignable.
            fatalError()
            
        }
        
        fatalError()
        
    }
    
    
}
