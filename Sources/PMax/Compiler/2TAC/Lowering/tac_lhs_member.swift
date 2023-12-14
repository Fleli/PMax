extension PILExpression {
    
    
    func lowerLHSMember(_ main: PILExpression, _ member: String, _ lowerer: TACLowerer, _ function: PILFunction) -> Location {
        
        let mainLocationAsLHS = main.lowerToTACAsLHS(lowerer, function)
        
        guard case .struct(let name) = main.type else {
            // Incorrect attempts to access non-struct member should have been caught in PIL.
            fatalError()
        }
        
        let structMemoryLayout = lowerer.pilLowerer.structLayouts[name]!
        let memberLocationInformation = structMemoryLayout.fields[member]!
        let memberOffset = memberLocationInformation.start
        
        switch mainLocationAsLHS {
        case .framePointer(let offset):
            
            let newOffset = offset + memberOffset
            return .framePointer(offset: newOffset)
            
        case .literalValue(_):
            
            // Errors such as '6.b' are caught in PIL as part of type-checking, so this should be unreachable.
            fatalError()
            
        case .rawPointer(let argumentFramePointerOffset):
            
            guard case .framePointerOffset(let int) = argumentFramePointerOffset else {
                // TODO: Reachable. Should submit error from here.
                fatalError()
            }
            
            let memberOffsetLiteral = Location.literalValue(value: memberOffset)
            let offset = declareAddressSum(lowerer, memberOffsetLiteral, int)
            
            return .rawPointer(.framePointerOffset(offset))
            
        }
        
    }
    
    
    private func declareAddressSum(_ lowerer: TACLowerer, _ memberOffsetLiteralLocation: Location, _ offset: Int) -> Int {
        
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
        
        guard case .framePointer(let offset) = location else {
            fatalError()
        }
        
        return offset
        
    }
    
    
}
