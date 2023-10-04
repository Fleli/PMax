class Environment {
    
    let structTypes: [String : StructType]
    let functionLabels: [String : FunctionLabel]
    
    var scopes: [Scope] = []
    
    let aspartame: Aspartame
    let decarbonator: Decarbonator
    
    private(set) var labels: Set<Label> = []
    
    init(_ decarbonator: Decarbonator, _ aspartame: Aspartame) {
        
        self.structTypes = decarbonator.structTypes
        self.functionLabels = decarbonator.functionLabels
        
        self.aspartame = aspartame
        self.decarbonator = decarbonator
        
    }
    
    func prepareForNewFunction() {
        scopes.removeAll()
        setUpFunctionScope()
    }
    
    private func setUpFunctionScope() {
        let functionScope = Scope(decarbonator, aspartame)
        scopes.append(functionScope)
    }
    
    func pushScope() {
        let parent = active()
        let newScope = Scope(parent)
        scopes.append(newScope)
    }
    
    func popScope() {
        scopes.removeLast()
    }
    
    func active() -> Scope {
        return scopes[scopes.count - 1]
    }
    
    /// Create a new `Label`. Its `weakContext` is simply used to give an indication of which context it is used in. It is used in the resulting assembly program to make it more readable.
    func label(_ weakContext: String) -> Label {
        let label = Label(weakContext)
        labels.insert(label)
        return label
    }
    
}
