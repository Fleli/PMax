extension Scope {
    
    /// Verify that an assignment is semantically meaningul. Infer the type of `lhs` if it is `.mustBeInferred`. Returns `nil` and produces an error if
    /// (a) the type of `rhs` is `.mustBeInferred` (in which case the assignment to `rhs` must have went wrong earlier on), or
    /// (b) either `lhs` or `rhs` does not exist (is not declared), or
    /// (c) the types of `lhs` and `rhs` do not match.
    func assignmentSemantics(_ lhs: String, _ rhs: String) -> [DecarbonatedStatement] {
        
        guard var lhsType = type(lhs) else {
            decarbonator.submitError(.variableDoesNotExist(name: lhs))
            return []
        }
        
        guard let rhsType = type(rhs) else {
            decarbonator.submitError(.variableDoesNotExist(name: rhs))
            return []
        }
        
        if case .mustBeInferred = rhsType {
            // We assume that an error was produced earlier if the type of `rhs` is still `.mustBeInferred`
            // TODO: Verify that this assumption holds.
            return []
        }
        
        if case .mustBeInferred = lhsType {
            inferType(of: lhs, to: rhsType)
            lhsType = rhsType
        }
        
        guard let lhsOffset = framePointerOffset(lhs), let rhsOffset = framePointerOffset(rhs) else {
            fatalError("Should never fail since types are already found.")
        }
        
        return [DecarbonatedStatement.memCopy(lhsOffset, rhsOffset)]
        
    }
    
}
