extension PILExpression {
    
    
    private static var offsetCalculationCount = 0
    
    
    func lowerToTACAsLHS(_ lowerer: TACLowerer) -> Location {
        
        
        switch value {
            
        case .variable(let variable):
            
            return lowerer.local.getVariable(variable).location
            
        case .dereference(let dereferenced):
            
            guard case .framePointer(let offset) = dereferenced.lowerToTAC(lowerer) else {
                // TODO: The assumption that this guard never fails may not be right. Double-check this.
                fatalError()
            }
            
            return Location.rawPointer(offset: offset)
            
        case .member(let main, let member):
            
            let mainLocationAsLHS = main.lowerToTACAsLHS(lowerer)
            
            guard case .struct(let name) = main.type else {
                // Incorrect attempts to access non-struct member should be caught in PIL.
                fatalError()
            }
            
            let structMemoryLayout = lowerer.pilLowerer.structLayouts[name]!
            let memberLocationInformation = structMemoryLayout.fields[member]!
            let memberOffset = memberLocationInformation.start
            
            // let memberLength = memberLocationInformation.length
            
            if case .framePointer(let offset) = mainLocationAsLHS {
                
                let newOffset = offset + memberOffset
                return .framePointer(offset: newOffset)
                
            }
            
            // Since the main expression is treated as a left-hand side expression, we may get a raw pointer from it.
            if case .rawPointer(let offset) = mainLocationAsLHS {
                
                // TODO: This part this thorough testing. Using the literal pool from PIL in TAC lowering is extremely risky since things may get out of sync. Finding a good solution to this is preferable.
                
                // The raw pointer's value (the value stored in [fp + offset]) is unknown at compile-time. But the member-offset is known, so we do an addition between the unknown and the known value.
                
                // The known value is converted to a string and treated as a literal addition to the pointer value. We notify the literal pool and fetch the corresponding variable.
                let memberOffsetString = "\(memberOffset)"
                let memberOffsetLiteral = lowerer.pilLowerer.literalPool.integerLiteral(memberOffsetString)
                
                if !lowerer.local.variableExists(memberOffsetLiteral) {
                    lowerer.local.declareInDataSection(.int, memberOffsetLiteral)
                }
                
                let memberOffsetLiteralLocation = lowerer.local.getVariable(memberOffsetLiteral).location
                
                Self.offsetCalculationCount += 1
                
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
                    // Should never happen
                    // TODO: Verify this.
                    fatalError()
                }
                
                return .rawPointer(offset: offset)
                
            }
            
        default:
            
            // TODO: Remove this fatal error and submit an error instead.
            // Only dereferences, members and variables are assignable.
            fatalError()
            
        }
        
        fatalError()
        
    }
    
    
}
