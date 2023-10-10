enum PILStatement {
    
    /// Declarations are so simple that they are stored as two associated types (`type: PILType` and `name: String`) instead of as pointer-to-`PILDeclaration` (which therefore does not exist).
    /// Declarations with an initial value are converted to a declaration followed by an assignment (and are therefore split into two seemingly unrelated statements).
    case declaration(type: PILType, name: String)
    
    
    case assignment(lhs: String, rhs: PILExpression)
    
}
