extension PILExpression {
    
    
    func lowerLHSMember(_ main: PILExpression, _ member: String, _ lowerer: TACLowerer) -> Location {
        
        let mainLocationAsLHS = main.lowerToTACAsLHS(lowerer)
        
        guard case .struct(let name) = main.type else {
            // Incorrect attempts to access non-struct member should be caught in PIL.
            fatalError()
        }
        
        let structMemoryLayout = lowerer.pilLowerer.structLayouts[name]!
        let memberLocationInformation = structMemoryLayout.fields[member]!
        let memberOffset = memberLocationInformation.start
        
        // let memberLength = memberLocationInformation.length
        
        switch mainLocationAsLHS {
        case .framePointer(let offset):
            
            let newOffset = offset + memberOffset
            return .framePointer(offset: newOffset)
            
        case .dataSection(_):
            
            // Impossible since only magicly named variables appear in the data section, and the programmer does not have access to those names (they won't be interpreted as identifiers by the lexer).
            fatalError()
            
        case .rawPointer(let argumentFramePointerOffset):
            
            // The `argumentFramePointerOffset` represents the offset from the frame pointer of the variable holding the address that this raw pointer points to.
            
            // TODO: This part needs thorough testing. Using the literal pool from PIL in TAC lowering is extremely risky since things may get out of sync. Finding a good solution to this is preferable.
            
            // The raw pointer's value (the value stored in [fp + offset]) is unknown at compile-time. But the member-offset is known, so we do an addition between the unknown and the known value.
            
            // The known value is converted to a string and treated as a literal addition to the pointer value. We notify the literal pool and fetch the corresponding variable.
            let memberOffsetLiteral = declareMemberOffsetLiteral(lowerer, argumentFramePointerOffset)
            let memberOffsetLiteralLocation = lowerer.local.getVariable(memberOffsetLiteral).location
            
            let location = declareAddressSum(lowerer, memberOffsetLiteralLocation, argumentFramePointerOffset)
            
            guard case .framePointer(let offset) = location else {
                // TODO: Verify that this is unreachable.
                fatalError(location.description)
            }
            
            return .rawPointer(offset: offset)
            
        }
        
        
    }
    
    
    private func declareMemberOffsetLiteral(_ lowerer: TACLowerer, _ memberOffset: Int) -> String {
        
        let memberOffsetString = "\(memberOffset)"
        let memberOffsetLiteral = lowerer.pilLowerer.literalPool.integerLiteral(memberOffsetString)
        
        Self.offsetCalculationCount += 1
        
        if !lowerer.local.variableExists(memberOffsetLiteral) {
            lowerer.local.declareInDataSection(.int, memberOffsetLiteral)
        }
        
        return memberOffsetLiteral
        
    }
    
    
    private func declareAddressSum(_ lowerer: TACLowerer, _ memberOffsetLiteralLocation: Location, _ offset: Int) -> Location {
        
        let newVariable = "$fp\(Self.offsetCalculationCount)"
        let location = lowerer.local.declare(.int, newVariable)
        
        let mainLocation = Location.framePointer(offset: offset)
        
        let assignment = TACStatement
            .assignBinaryOperation(
                lhs: location,
                operation: .init(rawValue: "+")!,
                arg1: memberOffsetLiteralLocation,
                arg2: mainLocation
            )
        
        lowerer.activeLabel.newStatement(assignment)
        
        return location
        
    }
    
    
}
