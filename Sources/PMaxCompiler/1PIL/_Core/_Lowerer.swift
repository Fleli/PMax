class PILLowerer {
    
    /// The `PILLowerer`'s `literalPool` is availble internally so that functions that lower from syntactic statements to `PIL` can notify the literal pool of newly encountered literals.
    let literalPool: LiteralPool
    
    /// The `local` scope is used to notify the `PILLowerer`'s environment of declarations, and to verify the existence of variables when they are referenced.
    var local: PILScope!
    
    
    private let topLevelStatements: TopLevelStatements
    
    private var functions: [String : PILFunction] = [:]
    
    init(_ topLevelStatements: TopLevelStatements) {
        
        self.topLevelStatements = topLevelStatements
        self.literalPool = LiteralPool()
        
        self.local = PILScope(self)
        
    }
    
    
    func lower() {
        prepare()
    }
    
    private func prepare() {
        
        for syntacticStatement in topLevelStatements {
            
            switch syntacticStatement {
            case .struct(_):
                continue
            case .function(let function):
                let name = function.name
                let pilFunction = PILFunction(function, self)
                functions[name] = pilFunction
                print(pilFunction)
                pilFunction.body.forEach {
                    $0._print(1)
                }
            }
            
        }
        
    }
    
    func push() {
        local = PILScope(local)
    }
    
    func pop() {
        local = local.parent!
    }
    
    /// Verify that `type` is a struct and that it has a field named `field`. Return the type if it exists.
    func fieldType(_ field: String, of type: PILType) -> PILType {
        
        if case .error = type {
            return .error
        }
        
        guard case .struct(let name) = type else {
            // TODO: Submit error (cannot find members of a non-struct type)
            return .error
        }
        
        // TODO: Find a PILStruct instance and check if it contains the given field.
        return .error
        
    }
    
    func functionType(_ functionName: String) -> PILType {
        return functions[functionName]?.type ?? .error
    }
    
}
