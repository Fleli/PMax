extension PILIfStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer, _ continueLabel: Label, _ function: PILFunction) {
        
        // Vi begynner med å hoppe til condition-evalueringen
        let conditionEvaluationLabel = lowerer.newLabel("if_condition", false, function)
        let jump = TACStatement.jump(label: conditionEvaluationLabel.name)
        lowerer.activeLabel.newStatement(jump)
        
        // Så gjør vi klar body-labelen (for true condition)
        let bodyInitLabel = lowerer.newLabel("if_body", false, function)
        
        // Så svitsjer vi over til condition-bergeningslabelen.
        lowerer.activeLabel = conditionEvaluationLabel
        
        // Der evaluerer vi faktisk condition
        let conditionEvaluationResult = condition.lowerToTAC(lowerer, function)
        
        // Dersom true, så hopper vi til bodyInitLabel. Der utfører vi instruksjoner og hopper til `continueLabel` når ferdig.
        let jumpIfTrue = TACStatement.jumpIfNonZero(label: bodyInitLabel.name, variable: conditionEvaluationResult)
        lowerer.activeLabel.newStatement(jumpIfTrue)
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
        lowerer.activeLabel = conditionEvaluationLabel
        
        if let `else` {
            
            // Siden `if`-en har en tilhørende `else`, lager vi en label som den kan bruke.
            let elseLabel = lowerer.newLabel("if_else", false, function)
            
            // Så hopper vi til denne, og lar else-`if`-en utføre sitt. Den skal fortsette på `continueLabel`.
            let jumpToElse = TACStatement.jump(label: elseLabel.name)
            lowerer.activeLabel.newStatement(jumpToElse)
            
            `else`.lowerToTAC(lowerer, continueLabel, function)
            
        } else {
            
            // Siden `if`-en ikke hadde noen tilhørende `else`, hopper vi bare fra condition evaluation til `continueLabel`.
            let jumpToContinue = TACStatement.jump(label: continueLabel.name)
            lowerer.activeLabel.newStatement(jumpToContinue)
            
        }
        
        lowerer.activeLabel = continueLabel
        
    }
    
    
}