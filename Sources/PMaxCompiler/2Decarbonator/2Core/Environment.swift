class Environment {
    
    let structTypes: [String : StructType]
    let functionLabels: [String : FunctionLabel]
    
    var scopes: [Scope] = []
    
    init(_ decarbonator: Decarbonator) {
        
        self.structTypes = decarbonator.structTypes
        self.functionLabels = decarbonator.functionLabels
        
        let functionScope = Scope(decarbonator)
        scopes.append(functionScope)
        
    }
    
    func pushScope() {
        let parent = scopes[scopes.count - 1]
        let newScope = Scope(parent)
        scopes.append(newScope)
    }
    
    func popScope() {
        scopes.removeLast()
    }
    
}
