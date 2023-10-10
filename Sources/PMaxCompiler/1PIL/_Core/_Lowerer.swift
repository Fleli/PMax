class PILLowerer {
    
    
    private let topLevelStatements: TopLevelStatements
    
    private var functions: [String : PILFunction] = [:]
    
    
    init(_ topLevelStatements: TopLevelStatements) {
        self.topLevelStatements = topLevelStatements
    }
    
    
    func lower() {
        prepare()
        findOperatorDeclarations()
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
            }
            
        }
        
    }
    
    private func findOperatorDeclarations() {
        // TODO: Include operator declarations in the compiler's first version.
    }
    
}
