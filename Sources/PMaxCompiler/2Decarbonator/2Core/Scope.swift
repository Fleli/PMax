class Scope {
    
    let decarbonator: Decarbonator
    
    private let parent: Scope?
    
    private var declarations: [String : DataType] = [:]
    
    init(_ parent: Scope) {
        self.parent = parent
        self.decarbonator = parent.decarbonator
    }
    
    init(_ decarbonator: Decarbonator) {
        self.parent = nil
        self.decarbonator = decarbonator
    }
    
    func declare(_ name: String, _ type: DataType) {
        
        if let alreadyDeclaredType = declarations[name] {
            
            return
        }
        
    }
    
}
