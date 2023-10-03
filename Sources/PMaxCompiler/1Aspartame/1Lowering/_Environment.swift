/// An environment serves as the source of type and declaration information within a function. It has access to the global `Aspartame` instance, allowing it to see all types and function declarations. It also keeps track of which scope is currently active and can search through all scopes to find the most local one that fits a certain reference.
class Environment {
    
    
    let aspartame: Aspartame
    
    var stack: [Scope]
    
    init(_ aspartame: Aspartame) {
        
        self.aspartame = aspartame
        
        let functionScope = Scope(aspartame)
        stack = [functionScope]
        
    }
    
    
    func declare(_ declaration: Declaration) {
        localScope().declare(declaration)
    }
    
    private func localScope() -> Scope {
        return stack[stack.count - 1]
    }
    
    
}
