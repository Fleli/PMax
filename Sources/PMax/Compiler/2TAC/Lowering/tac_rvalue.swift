extension PILExpression {
    
    /// The `lowerToTACAsRValue(_:_:)` method on `PILExpression` lowers a `PILExpression` to three-address code.
    /// It also returns the `RValue` describing the expression.
    func lowerToTACAsRValue(_ lowerer: TACLowerer, _ function: PILFunction) -> RValue {
        
        switch value {
        case .unary(let `operator`, let arg):
            
            /// `argument` represents `arg` (the unary operator's argument) lowered to TAC as an `RValue`.
            let argument = arg.lowerToTACAsRValue(lowerer, function)
            
            /// `resultOffset` is the frame pointer offset of the variable holding the result of the operation.
            /// The result is treated first as an `LValue` (when we apply the operator), and then as an `RValue` (when we return it).
            let resultOffset = lowerer.newInternalVariable("un\(`operator`.rawValue)", self.type)
            
            /// The `TAC` statement corresponding to the unary operation in question. Here, the result is treated as an `LValue` since we're writing into it.
            let tac = TACStatement.assignUnaryOperation(
                lhs: .stackAllocated(framePointerOffset: resultOffset),
                operation: `operator`,
                arg: argument
            )
            
            lowerer.activeLabel.newStatement(tac)
            
            // When we're done, we treat the result as an `RValue`.
            return .stackAllocated(framePointerOffset: resultOffset)
            
        case .binary(let `operator`, let arg1, let arg2):
            
            /// `argument1` represents `arg1` (the binary operator's 1st argument) lowered to TAC as an `RValue`.
            let argument1 = arg1.lowerToTACAsRValue(lowerer, function)
            
            /// `argument2` represents `ar2` (the binary operator's 2nd argument) lowered to TAC as an `RValue`.
            let argument2 = arg2.lowerToTACAsRValue(lowerer, function)
            
            /// `resultOffset` is the frame pointer offset of the variable holding the result of the operation.
            /// The result is treated first as an `LValue` (when we apply the operator), and then as an `RValue` (when we return it).
            let resultOffset = lowerer.newInternalVariable("bin\(`operator`.rawValue)", self.type)
            
            let tac = TACStatement.assignBinaryOperation(
                lhs: .stackAllocated(framePointerOffset: resultOffset),
                operation: `operator`,
                arg1: argument1,
                arg2: argument2
            )
            
            /// The `TAC` statement corresponding to the binary operation in question. Here, the result is treated as an `LValue` since we're writing into it.
            lowerer.activeLabel.newStatement(tac)
            
            // When we're done, we treat the result as an `RValue`.
            return .stackAllocated(framePointerOffset: resultOffset)
            
        case .call(let pilCall):
            
            var loweredArguments: [(name: Location, size: Int)] = []
            
            // We first calculate each argument and remember their names.
            for argument in pilCall.arguments {
                let name = argument.lowerToTACAsRValue(lowerer, function)
                let words = lowerer.sizeOf(argument.type)
                loweredArguments.append((name, words))
            }
            
            // Then, we declare the name of the variable representing the returned value.
            let lhs = lowerer.newInternalVariable("call_\(pilCall.name)", self.type)
            
            guard case .framePointer(let returnValueOffset) = lhs else {
                fatalError("\(lhs)")
            }
            
            // We keep track of the next argument's position relative to the frame pointer.
            let returnSize = lowerer.sizeOf(lowerer.functions[pILCall.name]!.type)
            var argumentOffsetToOldFramePointer = returnValueOffset + returnSize + 2
            
            // Then, since the return value's offset is known, we can push each argument with the correct offset.
            for (name, words) in loweredArguments {
                let statement = TACStatement.pushParameter(at: name, words: words, framePointerOffset: argumentOffsetToOldFramePointer)
                argumentOffsetToOldFramePointer += words
                lowerer.activeLabel.newStatement(statement)
            }
            
            let returnLabel = lowerer.newLabel("\(pILCall.name)_ret", false, function)
            
            let callLabel = lowerer.getFunctionEntryPoint(pILCall.name)
            
            let retType = lowerer.functions[pILCall.name]!.type
            let retSize = lowerer.sizeOf(retType)
            let callStatement = TACStatement.call(lhs: lhs, functionLabel: callLabel, returnLabel: returnLabel.name, words: retSize)
            
            lowerer.activeLabel.newStatement(callStatement)
            
            // We switch the active label, so that code resumes not here but at the new location, which is reachable from the callee.
            lowerer.activeLabel = returnLabel
            
            // The result is stored in `lhs`, so we return it so that it is accessible to other statements as well.
            return lhs
            
        case .variable(let name):
            
            return lowerer.local.getVariable(name).1
            
        case .integerLiteral(let literal):
            
            guard let value = Int(literal), 0 <= value, value <= Builtin.intLiteralInclusiveBound else {
                lowerer.submitError(PMaxIssue.illegalIntegerLiteral(literal: literal))
                return .literalValue(value: 0)
            }
            
            return Location.literalValue(value: value)
            
        case .dereference(let pILExpression):
            
            let argument = pILExpression.lowerToTACAsRValue(lowerer, function)
            
            let lhs = lowerer.newInternalVariable("dereference", self.type)
            let words = lowerer.sizeOf(self.type)
            let statement = TACStatement.dereference(lhs: lhs, arg: argument, words: words)
            
            lowerer.activeLabel.newStatement(statement)
            
            return lhs
            
        case .addressOf(let pILExpression):
            
            let argument = pILExpression.lowerToTACAsRValue(lowerer, function)
            
            let lhs = lowerer.newInternalVariable("addressOf", self.type)
            let statement = TACStatement.addressOf(lhs: lhs, arg: argument)
            
            lowerer.activeLabel.newStatement(statement)
            
            if case .literalValue(_) = argument {
                lowerer.submitError(PMaxIssue.cannotFindAddressOfNonReference)
            }
            
            return lhs
            
        case .member(let main, let member):
            
            return lowerMemberToTAC(main, member, lowerer, function)
            
        }
        
    }
    
    
}
