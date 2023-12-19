extension PILIfStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer, _ continueLabel: Label, _ function: PILFunction) {
        
        // We start by jumping to the condition evaluation label
        let conditionEvaluationLabel = lowerer.newLabel("if_condition", false, function)
        let jump = TACStatement.jump(label: conditionEvaluationLabel.name)
        lowerer.activeLabel.newStatement(jump)
        
        // Then we prepare the body label
        let bodyInitLabel = lowerer.newLabel("if_body", false, function)
        
        // We then switch to the condition evaluation label and lower the condition evaluation
        lowerer.activeLabel = conditionEvaluationLabel
        let conditionEvaluationResult = condition.lowerToTAC(lowerer, function)
        
        // If the condition evaluates to true, we jump to the body label.
        let jumpIfTrue = TACStatement.jumpIfNonZero(label: bodyInitLabel.name, variable: conditionEvaluationResult)
        lowerer.activeLabel.newStatement(jumpIfTrue)
        
        // We might have moved to a new label during condition evaluation (e.g. if it contains a function call).
        let newConditionEvaluationLabel = lowerer.activeLabel
        
        lowerer.activeLabel = bodyInitLabel
        
        // Før vi begynner å lowere body, pusher vi et nytt scope slik at name resolution blir riktig. Vi popper dette etterpå.
        lowerer.push()
        
        for statement in body {
            statement.lowerToTAC(lowerer, function)
        }
        
        let jumpToContinue = TACStatement.jump(label: continueLabel.name)
        lowerer.activeLabel.newStatement(jumpToContinue)
        
        lowerer.pop()
        
        // Vi svitsjer nå tilbake til conditionEvaluationLabel, for vi må også gjøre noe dersom condition failet.
        lowerer.activeLabel = newConditionEvaluationLabel
        
        if let `else` {
            
            // Siden `if`-en har en tilhørende `else`, lager vi en label som den kan bruke.
            let elseLabel = lowerer.newLabel("if_else", false, function)
            
            // Så hopper vi til denne, og lar else-`if`-en utføre sitt. Den skal fortsette på `continueLabel`.
            let jumpToElse = TACStatement.jump(label: elseLabel.name)
            lowerer.activeLabel.newStatement(jumpToElse)
            
            lowerer.activeLabel = elseLabel
            
            `else`.lowerToTAC(lowerer, continueLabel, function)
            
        } else {
            
            // Siden `if`-en ikke hadde noen tilhørende `else`, hopper vi bare fra condition evaluation til `continueLabel`.
            let jumpToContinue = TACStatement.jump(label: continueLabel.name)
            lowerer.activeLabel.newStatement(jumpToContinue)
            
        }
        
        lowerer.activeLabel = continueLabel
        
    }
    
    
}
