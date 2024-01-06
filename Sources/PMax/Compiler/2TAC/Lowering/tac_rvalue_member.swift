extension PILExpression {
    
    /*
    func lowerToTACAsMemberRValue(_ main: PILExpression, _ member: String, _ lowerer: TACLowerer, _ function: PILFunction) -> RValue {
        
        var mainResult = main.lowerToTACAsRValue(lowerer, function)
        
        let lhs = lowerer.newInternalVariable("member", self.type)
        
        guard case .`struct`(let structName) = main.type, case .framePointer(let offset) = mainResult else {
            fatalError()
        }
        
        
        switch mainResult {
        case .stackAllocated(let framePointerOffset):
            <#code#>
        case .integerLiteral(let value):
            <#code#>
        case .dereference(let framePointerOffset):
            <#code#>
        }
        
        
        let layout = lowerer.structLayout(structName)
        let localOffset = layout.fields[member]!.start
        
        mainResult = .framePointer(offset: offset + localOffset)
        
        let wordsToAssign = lowerer.sizeOf(self.type)
        let statement = TACStatement.assign(lhs: lhs, rhs: mainResult, words: wordsToAssign)
        
        lowerer.activeLabel.newStatement(statement)
        
        return lhs
        
    }
    */
    
}
