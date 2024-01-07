extension PILExpression {
    
    
    func lowerToTACAsMemberRValue(_ main: PILExpression, _ member: String, _ lowerer: TACLowerer, _ function: PILFunction) -> RValue {
        
        /// Lower the struct instance to TAC as an RValue. Treat the result as an `LValue`.
        let loweredMain = main.lowerToTACAsRValue(lowerer, function).treatAsLValue()
        
        // Calculate offsets etc. using the LValue algorithm, since they are identical at this point. Treat the result from there as an RValue.
        return lowerToTACAsMemberLValue(main.type, loweredMain, member, lowerer, function).treatAsRValue()
        
    }
    
    
}
