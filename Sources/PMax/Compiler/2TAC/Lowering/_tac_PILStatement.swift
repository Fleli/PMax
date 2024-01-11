extension PILStatement {
    
    
    func lowerToTAC(_ lowerer: TACLowerer, _ function: PILFunction) {
        
        switch self {
            
        case .declaration(let type, let name):
            
            // Declarations do not add any new statements. They just inform the local scope about the variable's existence.
            lowerer.local.declare(type, name)
            
        case .assignment(let lhs, let rhs):
            
            let lhsLocation = lhs.lowerToTACAsLValue(lowerer, function)
            let rhsLocation = rhs.lowerToTACAsRValue(lowerer, function)
            
            let wordsToAssign = lowerer.sizeOf(lhs.type)
            let statement = TACStatement.assign(lhs: lhsLocation, rhs: rhsLocation, words: wordsToAssign)
            lowerer.activeLabel.newStatement(statement)
            
        case .return(let expression):
            
            let value = expression?.lowerToTACAsRValue(lowerer, function)
            
            var words = 0
            
            if let t = expression?.type {
                
                words = lowerer.sizeOf(t)
                
            }
            
            var fOffset: Int? = nil
            
            if let value {
                
                switch value {
                case .stackAllocated(let framePointerOffset):
                    
                    fOffset = framePointerOffset
                    
                case .integerLiteral(let literal):
                    
                    let literalVariable = lowerer.newInternalVariable("literal\(literal)", .int)
                    lowerer.activeLabel.newStatement(TACStatement.assign(lhs: .stackAllocated(framePointerOffset: literalVariable), rhs: value, words: 1))
                    fOffset = literalVariable
                    
                case .dereference(let framePointerOffset):
                    
                    // TODO: Should avoid cases like these.
                    fatalError("Unreachable: \(framePointerOffset).")
                    
                }
                
            }
            
            let statement = TACStatement.return(returnValueFramePointerOffset: fOffset, words: words)
            lowerer.activeLabel.newStatement(statement)
             
        case .if(let pILIfStatement):
            
            let continueLabel = lowerer.newLabel("@if_next", false, function)
            pILIfStatement.lowerToTAC(lowerer, continueLabel, function)
            
        case .while(let condition, let body):
            
            // After the while loop is finished, we start to work on nextLabel.
            let nextLabel = lowerer.newLabel("@while_next", false, function)
            
            // We also generate the body label, which is where the while loop's body begins.
            let bodyLabel = lowerer.newLabel("@while_body", false, function)
            
            // Create the condition evaluation label and jump to it
            let conditionEvaluationLabel = lowerer.newLabel("@while_condition", false, function)
            let jumpToConditionEvaluation = TACStatement.jump(label: conditionEvaluationLabel.name)
            lowerer.activeLabel.newStatement(jumpToConditionEvaluation)
            
            // Then, actually move to (activate) it.
            lowerer.activeLabel = conditionEvaluationLabel
            
            // If the condition is true, move to the body.
            let conditionResult = condition.lowerToTACAsRValue(lowerer, function)
            let jumpToBody = TACStatement.jumpIfNonZero(label: bodyLabel.name, condition: conditionResult)
            lowerer.activeLabel.newStatement(jumpToBody)
            
            // We remember which label the condition evaluation ended at (in case it changed)
            // This is needed for the case where the condition is evaluated to false.
            let conditionEvaluationFinalLabel = lowerer.activeLabel
            
            // We now move to the body and lower all of its statements. At the end of the body, insert a jump to the condition evaluator.
            lowerer.activeLabel = bodyLabel
            
            // Before we lower any statements, we make sure to push a new scope since the `while` loop's body is within { ... }. We pop the scope afterwards.
            
            lowerer.push()
            
            for statement in body {
                statement.lowerToTAC(lowerer, function)
            }
            
            let jumpBackToCondition = TACStatement.jump(label: conditionEvaluationLabel.name)
            lowerer.activeLabel.newStatement(jumpBackToCondition)
            
            lowerer.pop()
            
            // Now, we consider the case where the condition failed
            // So we move back to the final condition evaluation label and insert a jump to nextLabel.
            lowerer.activeLabel = conditionEvaluationFinalLabel
            let jumpToNext = TACStatement.jump(label: nextLabel.name)
            lowerer.activeLabel.newStatement(jumpToNext)
            
            // Finally, we just change the active label to nextLabel so future statements end up there.
            lowerer.activeLabel = nextLabel
            
        }
        
        
    }
    
    
}
