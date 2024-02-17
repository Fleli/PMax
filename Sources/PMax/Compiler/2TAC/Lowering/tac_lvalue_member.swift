extension PILExpression {
    
    
    func lowerToTACAsMemberLValue(_ main: PILExpression, _ member: String, _ lowerer: TACLowerer, _ function: PILFunction) -> LValue {
        
        let mainLValue = main.lowerToTACAsLValue(lowerer, function)
        
        return lowerToTACAsMemberLValue(main.type, mainLValue, member, lowerer, function)
        
    }
    
    
    // Split into two functions since RValue lowering uses the function below as a helper.
    
    
    func lowerToTACAsMemberLValue(_ mainType: PILType, _ mainLValue: LValue, _ member: String, _ lowerer: TACLowerer, _ function: PILFunction) -> LValue {
        
        guard case .struct(let name) = mainType else {
            // Incorrect attempts to access non-struct member should have been caught in PIL.
            // TODO: Check if this guard statement could somehow be removed.
            fatalError()
        }
        
        /// Represents the `MemoryLayout` of the (struct) type of the main expression.
        let structMemoryLayout = lowerer.structLayout(name)
        
        /// The internal offset (position relative to the struct's start) of the member in question.
        /// An internal offset of `k` means that the member starts `k` addresses after the start of the struct instance.
        let memberOffsetInStructInstance = structMemoryLayout.fields[member]!.start
        
        // Which kind of LValue the main expression is (stack-allocated or dereferenced) determines how we find a certain member as LValue.
        switch mainLValue {
            
        case .stackAllocated(let framePointerOffset):
            
            /// Represents the offset of the struct instance member.
            /// If a member `m` has an offset `k` within a struct instance `x` which itself is found at frame pointer offset `l`, then `m`'s frame pointer offset is `l + k`.
            /// When lowering as an LValue, we view this member as a variable allocated on the stack, since structs are really just groups of data packaged together.
            let memberOffset = framePointerOffset + memberOffsetInStructInstance
            
            return .stackAllocated(framePointerOffset: memberOffset)
            
        case .dereference(let framePointerOffset):
            
            /// Declare a new variable on the stack. This variable will hold the address of the member we're interested in.
            /// To accopmlish this, we find the sum of the address of the struct instance and the member's internal offset.
            let memberAddress = lowerer.newInternalVariable("lvalue_deref_\(member)_offset", .int)
            
            /// The `assignSumStatement` adds the value `[fp + framePointerOffset]` (i.e. the address of the struct instance) together with `memberOffsetInStructInstance` (i.e. the member's internal offset).
            let assignSumStatement = TACStatement.assignBinaryOperation(
                lhs: .stackAllocated(framePointerOffset: memberAddress),
                operation: TACStatement.Binary(rawValue: "+")!,
                arg1: .stackAllocated(framePointerOffset: framePointerOffset),
                arg2: .integerLiteral(value: memberOffsetInStructInstance)
            )
            
            // Add the assignment statement to the active label.
            lowerer.activeLabel.newStatement(assignSumStatement)
            
            // Our new internal variable, `memberAddress`, now contains the address of the member in question.
            // We therefore return it (as a dereference since the struct instance was treated as a dereference).
            return .dereference(framePointerOffset: memberAddress)
            
            
        }
        
    }
    
    
}
