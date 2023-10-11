class PILLowerer {
    
    /// The `PILLowerer`'s `literalPool` is availble internally so that functions that lower from syntactic statements to `PIL` can notify the literal pool of newly encountered literals.
    let literalPool: LiteralPool
    
    
    private let topLevelStatements: TopLevelStatements
    
    private var functions: [String : PILFunction] = [:]
    
    
    init(_ topLevelStatements: TopLevelStatements) {
        self.topLevelStatements = topLevelStatements
        self.literalPool = LiteralPool()
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
                pilFunction.body.forEach {
                    print($0)
                }
            }
            
        }
        
    }
    
    private func findOperatorDeclarations() {
        // TODO: Include operator declarations in the compiler's first version.
    }
    
}
