extension Aspartame {
    
    internal func lower(_ `if`: If, within functionLabel: FunctionLabel) -> ConditionResult {
        
        // NOTE: The arrangement of the statements matter here, because some of them have the side-effect of changing the `functionLabel`'s active label.
        // TODO: Double-check that this arrangement is correct.
        
        // (1) Generate the condition code. This is found on the same path that we came from.
        let conditionIntermediateResult = lower(`if`.condition)
        
        let conditionName = conditionIntermediateResult.resultName
        
        let returnLabel = Label()
        
        // (2) Generate the branch statement. This must be run to actually check the condition.
        let branchStatement = AspartameStatement.branchIfZero(lhs: conditionName, destination: returnLabel)
        
        // (A3) If the branch statement doesn't result in a branch, the result was not zero. This means that the condition was true, so we continue on the same path that we were.
        let body = lower(`if`.body, within: functionLabel)
        
        // (A4) Then we move to `returnLabel`, which is where the rest of the code together with this `if` statement is located.
        let jump = AspartameStatement.jump(destination: returnLabel)
        
        // Concatenate all the statements to be executed, in order.
        let statements = conditionIntermediateResult.statements + [branchStatement] + body + [jump]
        
        // Ignore `else if`s for now. They can be relatively easily added later.
        if let _ = `if`.elseIf {
            print("`else if`s not supported in Aspartame yet. They are ignored.")
        }
        
        return ConditionResult(returnLabel, statements)
        
    }
    
}
