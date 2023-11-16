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
            
        case .literalValue(_):
            
            #warning("Go over this properly.")
            // TODO: Do not fatalError() here. Instead, submit a proper error message.
            fatalError()
            
        case .rawPointer(let argumentFramePointerOffset):
            
            #warning("Review this part again, after substantial changes.")
            let memberOffsetLiteral = Location.literalValue(value: memberOffset)
            let location = declareAddressSum(lowerer, memberOffsetLiteral, argumentFramePointerOffset)
            
            guard case .framePointer(let offset) = location else {
                // TODO: Verify that this is unreachable.
                fatalError(location.description)
            }
            
            return .rawPointer(offset: offset)
            
        }
        
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
