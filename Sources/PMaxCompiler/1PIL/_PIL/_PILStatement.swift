enum PILStatement {
    
    /// Declarations are stored as two associated types (`type: PILType` and `name: String`).
    /// Declarations with an initial value are converted to a declaration followed by an assignment (and are therefore split into two seemingly unrelated statements).
    case declaration(type: PILType, name: String)
    
    /// Assign a variable.
    case assignment(lhs: PILExpression, rhs: PILExpression)
    
    /// Syntactic `return` statements are lowered to `PILStatement.return`, which has an (optional) `PILExpression` associated value representing the value being returned.
    case `return`(expression: PILExpression?)
    
    /// Since `if` statements are recursive (an `if` statement may include another `if` statement in its `else` clause), the `PILStatement.if` case points to a `PILIfStatement` class instance.
    case `if`(PILIfStatement)
    
    /// A lowered `while` statement, including its `condition` and `body`
    case `while`(condition: PILExpression, body: [PILStatement])
    
    
    func _print(_ indent: Int = 0) {
        
        let prefix = String(repeating: "|   ", count: indent)
        
        switch self {
        case .declaration(let type, let name):
            print(prefix + type.description + " " + name + ";")
        case .assignment(let lhs, let rhs):
            print(prefix + lhs.description + " = " + rhs.description + ";")
        case .return(let expression):
            print(prefix + "return \(expression?.description ?? "[void]");")
        case .if(let pILIfStatement):
            pILIfStatement._print(indent)
        case .while(let condition, let body):
            print(prefix + "while \(condition.description) {")
            body.forEach { $0._print(indent + 1) }
            print(prefix + "}")
        }
        
    }
    
    
}
