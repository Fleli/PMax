extension Scope {
    
    /// Returns an empty `[DecarbonatedStatement]` if something fails, so the caller need not worry about `nil`s.
    func literalAssignmentSemantics(_ lhs: String, _ intLiteral: String) -> [DecarbonatedStatement] {
        
        guard var lhsType = type(lhs), let lhsOffset = framePointerOffset(lhs) else {
            decarbonator.submitError(.variableDoesNotExist(name: lhs))
            return []
        }
        
        if case .mustBeInferred = lhsType {
            // TODO: In the first version of the compiler, an integer literal is always inferred to `__word`. This will change in future versions, but requires context to flow downwards (instead of only synthesizing types upwards).
            inferType(of: lhs, to: .__word)
            lhsType = .__word
        }
        
        guard let int = Int(intLiteral) else {
            // TODO: Check this assumption.
            fatalError("Should never happen.")
        }
        
        guard (0 <= int) && (int <= Builtin.intLiteralInclusiveBound) else {
            decarbonator.submitError(.intLiteralNotWithinBounds(literal: intLiteral))
        }
        
        let assignment = DecarbonatedStatement.storeImm(lhsOffset, int)
        
        return [assignment]
        
    }
    
}
