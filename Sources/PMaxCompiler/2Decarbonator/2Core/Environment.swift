class Environment {
    
    let structTypes: [String : StructType]
    let functionLabels: [String : FunctionLabel]
    
    var scopes: [Scope] = []
    
    let aspartame: Aspartame
    
    init(_ decarbonator: Decarbonator, _ aspartame: Aspartame) {
        
        self.structTypes = decarbonator.structTypes
        self.functionLabels = decarbonator.functionLabels
        
        self.aspartame = aspartame
        
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
    
    func label(for functionLabel: FunctionLabel) -> Label {
        
        
        
    }
    
}
