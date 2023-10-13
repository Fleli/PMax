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
    
    func declare(_ type: PILType, _ name: String) {
        
        if variables[name] != nil {
            // TODO: Submit error
            return
        }
        
        variables[name] = type
        
        print("Declared \(type) \(name)")
        
    }
    
    func getVariable(_ name: String) -> PILType? {
        print("Fetched \(variables[name]) at \(name)")
        return variables[name]
    }
    
}
