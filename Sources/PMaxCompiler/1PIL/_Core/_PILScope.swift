class PILScope {
    
    let parent: PILScope?
    
    private var variables: [String : PILType] = [:]
    
    private weak var lowerer: PILLowerer?
    
    init(_ lowerer: PILLowerer) {
        self.parent = nil
        self.lowerer = lowerer
    }
    
    init(_ parent: PILScope) {
        self.parent = parent
        self.lowerer = parent.lowerer
    }
    
    /// Declare a variable in this scope. Returns `false` if the declaration failed (the variable already exists within this scope), and `true` otherwise. If it returns `true`, the caller can be certain that it has been added to the scope and is available for future references. If it returns `false`, an error is submitted. Therefore, the caller need not worry about submitting errors regardless of the result.
    @discardableResult
    func declare(_ type: PILType, _ name: String) -> Bool {
        
        if let existing = variables[name] {
            lowerer!.submitError(.redeclarationOfVariable(varName: name, existing: existing, new: type))
            return false
        }
        
        variables[name] = type
        return true
        
    }
    
    func getVariable(_ name: String) -> PILType? {
        
        if let local = variables[name] {
            return local
        } else if let parent {
            return parent.getVariable(name)
        }
        
        return nil
        
    }
    
}
