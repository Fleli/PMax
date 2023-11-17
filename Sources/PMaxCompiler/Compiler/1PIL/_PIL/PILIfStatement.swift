class PILIfStatement {
    
    let condition: PILExpression
    
    let body: [PILStatement]
    
    let `else`: PILIfStatement?
    
    init(_ condition: PILExpression, _ body: [PILStatement], _ `else`: PILIfStatement? = nil) {
        self.condition = condition
        self.body = body
        self.`else` = `else`
    }
    
    func returnsOnAllPaths(_ expectedType: PILType, _ lowerer: PILLowerer) -> Bool {
        
        guard let `else`, `else`.statementsReturnOnAllPaths(expectedType, lowerer) else {
            return false
        }
        
        return self.statementsReturnOnAllPaths(expectedType, lowerer)
        
    }
    
    func statementsReturnOnAllPaths(_ expectedType: PILType, _ lowerer: PILLowerer) -> Bool {
        // Check if at least one statement returns on all paths: Then the `if`'s body returns on all paths.
        return body.reduce(false, {$0 || $1.returnsOnAllPaths(expectedType, lowerer)})
    }
    
    func printableDescription(_ indent: Int) -> String {
        
        let prefix = String(repeating: "    ", count: indent)
        
        var string = prefix + "if \(condition.description) {\n"
        
        for stmt in body {
            string += stmt.printableDescription(indent + 1)
        }
        
        string += prefix + "}\n"
        
        if let `else` {
            string += `else`.printableDescription(indent)
        }
        
        return string
        
    }
    
}
