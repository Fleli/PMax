enum AspartameStatement {
    
    case declaration(name: String, type: DataType)
    case assignment(lhs: String, rhs: String)
    
    // TODO: Follow this up.
    /// Integer literals are still stored as strings because further semantic checks (bounds etc.) are checked later
    case assignIntegerLiteral(lhs: String, literal: String)
    
    /// Used if we have a reference `r` and want to access a member `m`, and store this in `s` using dot syntax `s = r.m`.
    case accessMember(lhs: String, rhs: String, member: String)
    
}

