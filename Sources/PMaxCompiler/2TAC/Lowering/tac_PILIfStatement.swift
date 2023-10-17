extension PILIfStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer, _ activeLabel: Label) {
        
        let conditionEvaluationLabel = lowerer.newLabel("if:condition")
        
        activeLabel.newStatement(.jump(label: conditionEvaluationLabel.name))
        
        
        
        let continueLabel = lowerer.newLabel("if:next")
        
    }
    
    
}
