class PILScope {
    
    /// The parent of this scope. The parent scope is often referred to as the _outer scope_.
    let parent: PILScope?
    
    /// A dicionary of the variables declared in this scope. Each name is mapped to its type.
    private(set) var variables: [String : PILType] = [:]
    
    /// The `PILLowerer` object associated with this `PILScope` instance.
    private weak var lowerer: PILLowerer?
    
    /// Initializes a new global scope. The scope is considered global because it won't have a parent scope (so no outer scope exists).
    init(_ lowerer: PILLowerer) {
        self.parent = nil
        self.lowerer = lowerer
    }
    
    /// Initialize a scope from a parent scope. The child will inherit the parent's associated `PILLowerer` instance.
    init(_ parent: PILScope) {
        self.parent = parent
        self.lowerer = parent.lowerer
    }
    
    /// Declare a variable in this scope. Returns `false` if the declaration failed (the variable already exists within this scope), and `true` otherwise. If it returns `true`, the caller can be certain that it has been added to the scope and is available for future references. If it returns `false`, an error is submitted. Therefore, the caller need not worry about submitting errors regardless of the result.
    @discardableResult
    func declare(_ type: PILType, _ name: String) -> Bool {
        
        if let existing = variables[name] {
            lowerer!.submitError(PMaxIssue.redeclarationOfVariable(varName: name, existing: existing, new: type))
            return false
        }
        
        variables[name] = type
        return true
        
    }
    
    /// Returns the type of a variable `name` if it exists (returns `nil` otherwise).
    /// Starts searching through this scope. If the variable is not found, it will (recursively) search the parent scope.
    /// Thus, the search starts locally and moves "out" towards the global scope.
    func getVariable(_ name: String) -> PILType? {
        
        if let local = variables[name] {
            return local
        } else if let parent {
            return parent.getVariable(name)
        }
        
        return nil
        
    }
    
}
