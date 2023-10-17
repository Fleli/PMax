extension PILIfStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer, _ continueLabel: Label) {
        
        // Her evalueres condition til if statementen
        let conditionEvaluationLabel = lowerer.newLabel("if:condition")
        let jump = TACStatement.jump(label: conditionEvaluationLabel.name)
        lowerer.activeLabel.newStatement(jump)
        
        
        
    }
    
    
}
