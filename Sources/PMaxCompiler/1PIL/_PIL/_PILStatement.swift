enum PILStatement {
    
    /// Declarations are stored as two associated types (`type: PILType` and `name: String`).
    /// Declarations with an initial value are converted to a declaration followed by an assignment (and are therefore split into two seemingly unrelated statements).
    case declaration(type: PILType, name: String)
    
    /// Assignments are stored with one `lhs: [String]` field representing the left-hand side of the assignment. Each element represents a member of the previous (the first is in the function's name space).
    /// They also have a `PILExpression` field representing the value to assign to the lelft-hand side reference.
    case assignment(lhs: [String], rhs: PILExpression)
    
    /// Syntactic `return` statements are lowered to `PILStatement.return`, which has an (optional) `PILExpression` associated value representing the value being returned.
    case `return`(expression: PILExpression?)
    
    /// Since `if` statements are recursive (an `if` statement may include another `if` statement in its `else` clause), the `PILStatement.if` case points to a `PILIfStatement` class instance.
    case `if`(PILIfStatement)
    
    /// A lowered `while` statement, including its `condition` and `body`
    case `while`(condition: PILExpression, body: [PILStatement])
    
}
