extension PILExpression {
    
    /// The `lowerToTAC(_:)` method on `PILExpression` lowers a `PILExpression` to three-address code. It also returns the name of the variable that contains the result of the computation.
    func lowerToTAC(_ lowerer: TACLowerer) -> Location {
        
        switch value {
        case .unary(let `operator`, let arg):
            
            let argument = arg.lowerToTAC(lowerer)
            let result = lowerer.newInternalVariable("unary:\(`operator`.rawValue)", self.type)
            
            // TODO: For types larger than one word, we need to move multiple words when assigning. Consider implementing one of two options:
            // (1) The context in which we submit the TAC statement literally submits _n_ TAC statements if there are _n_ words to copy.
            // (2) Each assignment statement in TAC includes a _size_ value that is used later on to decide how many words to move.
            // Comment: The second method seems better. It requires some more metainformation for each assignment, but the task of finding the exact number of raw words to move seems more relevant to an even lower-level stage than the TAC representation. Also, cluttering each lowering stage with loops etc. to submit the correct number of statements will reduce readability (it can probably be done easier in a later lowering stage that is _designed_ for it).
            // Note: Losing the context that is given as we lower to TAC may be problematic. Investiagte further how well this approach will work.
            
            let tac = TACStatement.assignUnaryOperation(lhs: result, operation: `operator`, arg: argument)
            lowerer.activeLabel.newStatement(tac)
            
            return result
            
        case .binary(let `operator`, let arg1, let arg2):
            
            let result = lowerer.newInternalVariable("binary:\(`operator`.rawValue)", self.type)
            
            let argument1 = arg1.lowerToTAC(lowerer)
            let argument2 = arg2.lowerToTAC(lowerer)
            
            let tac = TACStatement.assignBinaryOperation(lhs: result, operation: `operator`, arg1: argument1, arg2: argument2)
            lowerer.activeLabel.newStatement(tac)
            
            return result
            
        case .call(let pILCall):
            
            for argument in pILCall.arguments {
                
                let name = argument.lowerToTAC(lowerer)
                let statement = TACStatement.pushParameter(at: name)
                lowerer.activeLabel.newStatement(statement)
                
            }
            
            let lhs = lowerer.newInternalVariable("call to \(pILCall.name)", self.type)
            let returnLabel = lowerer.newLabel("call to \(pILCall.name):ret")
            let callStatement = TACStatement.call(lhs: lhs, function: pILCall.name, returnLabel: returnLabel.name)
            
            lowerer.activeLabel.newStatement(callStatement)
            
            // We switch the active label, so that code resumes not here but at the new location, which is reachable from the callee.
            lowerer.activeLabel = returnLabel
            
            // The result is stored in `lhs`, so we return it so that it is accessible to other statements as well.
            return lhs
            
        case .variable(let name):
            
            return lowerer.local.getVariable(name).1
            
        case .dereference(let pILExpression):
            
            let argument = pILExpression.lowerToTAC(lowerer)
            
            let lhs = lowerer.newInternalVariable("dereference", self.type)
            let statement = TACStatement.dereference(lhs: lhs, arg: argument)
            
            lowerer.activeLabel.newStatement(statement)
            
            return lhs
            
        case .addressOf(let pILExpression):
            
            let argument = pILExpression.lowerToTAC(lowerer)
            
            let lhs = lowerer.newInternalVariable("addressOf", self.type)
            let statement = TACStatement.addressOf(lhs: lhs, arg: argument)
            
            lowerer.activeLabel.newStatement(statement)
            
            return lhs
            
        case .member(let main, let member):
            
            var mainResult = main.lowerToTAC(lowerer)
            
            let lhs = lowerer.newInternalVariable("member", self.type)
            
            if case .`struct`(let structName) = main.type, case .framePointer(let offset) = mainResult {
                
                let layout = lowerer.pilLowerer.structLayouts[structName]
                let memberLayout = layout!.fields[member]!
                
                let localOffset = memberLayout.start
                
                mainResult = .framePointer(offset: offset + localOffset)
                
            } else {
                
                fatalError()
                
            }
            
            let statement = TACStatement.simpleAssign(lhs: lhs, rhs: mainResult)
            
            lowerer.activeLabel.newStatement(statement)
            
            return lhs
            
        }
        
    }
    
    
}
