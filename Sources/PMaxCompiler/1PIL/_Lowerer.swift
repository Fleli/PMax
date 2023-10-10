class PILLowerer {
    
    
    private let topLevelStatements: TopLevelStatements
    
    private var functions: [PILFunction] = []
    
    
    init(_ topLevelStatements: TopLevelStatements) {
        self.topLevelStatements = topLevelStatements
    }
    
    
    func lower() {
        prepare()
        findOperatorDeclarations()
        lowerToPIL()
    }
    
    private func prepare() {
        
        for syntacticStatement in topLevelStatements {
            
            switch syntacticStatement {
            case .struct(_):
                continue
            case .function(let function):
                let f = PILFunction(function, self)
                print(f)
                functions.append(f)
            }
            
        }
        
    }
    
    private func findOperatorDeclarations() {
        // TODO: Include operator declarations in the compiler's first version.
    }
    
    private func lowerToPIL() {
        
    }
    
}
