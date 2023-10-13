class PILLowerer {
    
    /// The `PILLowerer`'s `literalPool` is availble internally so that functions that lower from syntactic statements to `PIL` can notify the literal pool of newly encountered literals.
    let literalPool: LiteralPool
    
    
    private let topLevelStatements: TopLevelStatements
    
    private var functions: [String : PILFunction] = [:]
    
    private var infixOperators: [PILBinaryOperatorSignature : PILBinaryOperator] = [:]
    private var unaryOperators: [PILUnaryOperatorSignature : PILUnaryOperator] = [:]
    
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
                    $0._print(1)
                }
            case .operator(.binaryOperator(let binaryOperator)):
                let pilOp = PILBinaryOperator(binaryOperator, self)
                infixOperators[pilOp.signature] = pilOp
                print(pilOp)
            case .operator(.unaryOperator(let unaryOperator)):
                let pilOp = PILUnaryOperator(unaryOperator, self)
                unaryOperators[pilOp.signature] = pilOp
                print(pilOp)
            }
            
        }
        
    }
    
    private func findOperatorDeclarations() {
        // TODO: Include operator declarations in the compiler's first version.
    }
    
}
