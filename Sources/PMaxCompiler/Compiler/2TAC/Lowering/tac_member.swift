extension PILExpression {
    
    
    func lowerMemberToTAC(_ main: PILExpression, _ member: String, _ lowerer: TACLowerer) -> Location {
        
        var mainResult = main.lowerToTAC(lowerer)
        
        let lhs = lowerer.newInternalVariable("member", self.type)
        
        guard case .`struct`(let structName) = main.type, case .framePointer(let offset) = mainResult else {
            fatalError()
        }
        
        let layout = lowerer.pilLowerer.structLayouts[structName]
        let memberLayout = layout!.fields[member]!
        
        let localOffset = memberLayout.start
        
        mainResult = .framePointer(offset: offset + localOffset)
        
        let wordsToAssign = lowerer.sizeOf(self.type)
        let statement = TACStatement.assign(lhs: lhs, rhs: mainResult, words: wordsToAssign)
        
        lowerer.activeLabel.newStatement(statement)
        
        return lhs
        
    }
    
    
}
