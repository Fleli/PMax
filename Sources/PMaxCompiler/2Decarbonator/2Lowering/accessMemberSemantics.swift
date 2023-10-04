extension Scope {
    
    func accessMemberSemantics(_ lhs: String, _ rhs: String, _ member: String) -> [DecarbonatedStatement] {
        
        guard let lhsVariable = fetchVariable(lhs), let rhsVariable = fetchVariable(rhs) else {
            // fetchVariable takes care of error submission
            return []
        }
        
        guard case .struct(let structType) = rhsVariable.type else {
            decarbonator.submitError(.attemptedNonStructMember(variable: rhs, type: rhsVariable.type.description))
            return []
        }
        
        guard let structMember = structType.layout?.members[member] else {
            decarbonator.submitError(.doesNotHaveMember(variable: rhs, type: rhsVariable.type.description, member: member))
            return []
        }
        
        let rhsType = structMember.type
        let rhsFramePointerOffset = rhsVariable.framePointerOffset + structMember.framePointerOffset
        
        var lhsType = lhsVariable.type
        
        if case .mustBeInferred = lhsType {
            inferType(of: lhs, to: rhsType)
            lhsType = rhsType
        } else if lhsType != rhsType {
            decarbonator.submitError(.assignmentTypeMismatch(lhs: lhs, lhsType: lhsType.description, rhsType: rhsType.description))
            return []
        }
        
        let lhsFramePointerOffset = lhsVariable.framePointerOffset
        
        let assignment = DecarbonatedStatement.memCopy(lhsFramePointerOffset, rhsFramePointerOffset)
        
        return [assignment]
        
    }
    
}
