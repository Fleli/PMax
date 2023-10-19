extension PILStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer) {
        
        switch self {
            
        case .declaration(let type, let name):
            
            // Declarations do not add any new statements. They just inform the local scope about the variable's existence.
            lowerer.local.declare(type, name)
            
        case .assignment(_, _):
            
            // Not implemented
            fatalError()
            
        case .return(let expression):
            
            let value = expression?.lowerToTAC(lowerer, false)
            
            let statement = TACStatement.return(value: value)
            lowerer.activeLabel.newStatement(statement)
            
        case .if(let pILIfStatement):
            
            let continueLabel = lowerer.newLabel("if:next")
            pILIfStatement.lowerToTAC(lowerer, continueLabel)
            
        case .while(let condition, let body):
            
            // After the while loop is finished, we start to work on nextLabel.
            let nextLabel = lowerer.newLabel("while:next")
            
            // We also generate the body label, which is where the while loop's body begins.
            let bodyLabel = lowerer.newLabel("while:body")
            
            // Create the condition evaluation label and jump to it
            let conditionEvaluationLabel = lowerer.newLabel("while:condition")
            let jumpToConditionEvaluation = TACStatement.jump(label: conditionEvaluationLabel.name)
            lowerer.activeLabel.newStatement(jumpToConditionEvaluation)
            
            // Then, actually move to (activate) it.
            lowerer.activeLabel = conditionEvaluationLabel
            
            // If the condition is true, move to the body.
            let conditionResult = condition.lowerToTAC(lowerer, false)
            let jumpToBody = TACStatement.jumpIfNonZero(label: bodyLabel.name, variable: conditionResult)
            lowerer.activeLabel.newStatement(jumpToBody)
            
            // We now move to the body and lower all of its statements. At the end of the body, insert a jump to the condition evaluator.
            lowerer.activeLabel = bodyLabel
            body.forEach { $0.lowerToTAC(lowerer) }
            let jumpBackToCondition = TACStatement.jump(label: conditionEvaluationLabel.name)
            lowerer.activeLabel.newStatement(jumpBackToCondition)
            
            // Now, we consider the case where the condition failed. So we move back to the condition evaluation and insert a jump to nextLabel.
            lowerer.activeLabel = conditionEvaluationLabel
            let jumpToNext = TACStatement.jump(label: nextLabel.name)
            lowerer.activeLabel.newStatement(jumpToNext)
            
            // Finally, we just change the active label to nextLabel so future statements end up there.
            lowerer.activeLabel = nextLabel
            
        }
        
        
    }
    
    
}
