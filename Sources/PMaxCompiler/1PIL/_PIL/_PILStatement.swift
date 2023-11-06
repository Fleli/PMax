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
    
    
    /// The `returnsOnAllPaths` method examines whether a statement returns a value on all paths. It also _checks_ whether the returned type is correct, but it still returns `true` if a return is _present_ (even though the return statement may be semantically meaningless because of type mistmatch). Note: This method may be somewhat _too_ restrictive: It always returns `false` for `while` loops in case they never run, even though we may theoretically be able to determine at compile-time that it will.
    func returnsOnAllPaths(_ expectedType: PILType, _ lowerer: PILLowerer) -> Bool {
        
        switch self {
        case .declaration(_, _), .assignment(_, _), .while(_, _):
            
            return false
            
        case .return(let expression):
            
            let returnedType: PILType = expression?.type ?? .void
            
            if returnedType == .void  &&  expectedType == .void {
                return true
            }
            
            if !returnedType.assignable(to: expectedType) {
                lowerer.submitError(PMaxIssue.incorrectReturnType(expected: expectedType, given: returnedType))
            }
            
            return true
            
        case .if(let pILIfStatement):
            
            return pILIfStatement.returnsOnAllPaths(expectedType, lowerer)
            
        }
        
    }
    
    
    func printableDescription(_ indent: Int = 0) -> String {
        
        let prefix = String(repeating: "    ", count: indent)
        
        switch self {
        case .declaration(let type, let name):
            return prefix + type.description + " " + name + ";\n"
        case .assignment(let lhs, let rhs):
            return prefix + lhs.description + " = " + rhs.description + ";\n"
        case .return(let expression):
            return prefix + "return \(expression?.description ?? "[void]");\n"
        case .if(let pILIfStatement):
            return pILIfStatement.printableDescription(indent)
        case .while(let condition, let body):
            return prefix + "while \(condition.description) {\n"
            +   body.reduce("") { $0 + $1.printableDescription(indent + 1) + "\n" }
            +   prefix + "}\n"
        }
        
    }
    
    
}
