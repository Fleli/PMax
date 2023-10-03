/// Most `Expression`s have to introduce new, internal variables to be able to compute the result. The final variable actually containing the result, is found in the `result` property of `LoweredExpression`. All the statements that make up the `Expression`'s lowered form, are in `statements`.
struct LoweredExpression {
    
    let result: String
    let statements: [AspartameStatement]
    
    init(_ result: String, _ statements: [AspartameStatement]) {
        self.result = result
        self.statements = statements
    }
    
    static func directVariable(_ name: String) -> LoweredExpression {
        return LoweredExpression(name, [])
    }
    
}
