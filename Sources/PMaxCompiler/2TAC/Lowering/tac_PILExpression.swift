extension PILExpression {
    
    /// The `lowerToTAC(_:)` method on `PILExpression` lowers a `PILExpression` to three-address code. It also returns the name of the variable that contains the result of the computation.
    func lowerToTAC(_ lowerer: TACLowerer) -> Location {
        
        switch value {
        case .unary(let `operator`, let arg):
            
            let argument = arg.lowerToTAC(lowerer)
            let result = lowerer.newInternalVariable("unary:\(`operator`.rawValue)", self.type)
            
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
            
            let retType = lowerer.functions[pILCall.name]!.type
            let retSize = lowerer.sizeOf(retType)
            let callStatement = TACStatement.call(lhs: lhs, function: pILCall.name, returnLabel: returnLabel.name, words: retSize)
            
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
            let words = lowerer.sizeOf(self.type)
            let statement = TACStatement.dereference(lhs: lhs, arg: argument, words: words)
            
            lowerer.activeLabel.newStatement(statement)
            
            return lhs
            
        case .addressOf(let pILExpression):
            
            let argument = pILExpression.lowerToTAC(lowerer)
            
            let lhs = lowerer.newInternalVariable("addressOf", self.type)
            let statement = TACStatement.addressOf(lhs: lhs, arg: argument)
            
            lowerer.activeLabel.newStatement(statement)
            
            return lhs
            
        case .member(let main, let member):
            
            return lowerMemberToTAC(main, member, lowerer)
            
        }
        
    }
    
    
}
