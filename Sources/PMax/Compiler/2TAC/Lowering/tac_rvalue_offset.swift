extension PILExpression {
    
    /// The `lowerToTACAsStackAllocatedRValue(_:_:)` method on `PILExpression` lowers a `PILExpression` to three-address code.
    /// It calls `lowerToTACAsRValue(_:_:)` under the hood to do the actual lowering.
    /// It then extracts the frame pointer offset of the `RValue`, assuming it is in fact a stack-allocated variable.
    /// If it isn't, the program `fatalError`s since this indicates a compiler bug.
    func lowerToTACAsStackAllocatedRValue(_ lowerer: TACLowerer, _ function: PILFunction) -> Int {
        
        let rvalue = lowerToTACAsRValue(lowerer, function)
        
        guard case .stackAllocated(let framePointerOffset) = rvalue else {
            fatalError(
            """
            Compilation terminated due to an internal issue.
            RValue \(rvalue) was not stack allocated, but 'lowerToTACAsStackAllocatedRValue' was called.
            Context: {
                function: \(function.signature)
                expression: \(self)
            }
            Please submit an issue at https://github.com/Fleli/PMax to notify me of this compiler bug.
            """
            )
        }
        
        return framePointerOffset
        
    }
    
}
