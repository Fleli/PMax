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
            
            /// The `TAC` statement corresponding to the binary operation in question. Here, the result is treated as an `LValue` since we're writing into it.
            let tac = TACStatement.assignBinaryOperation(
                lhs: .stackAllocated(framePointerOffset: resultOffset),
                operation: `operator`,
                arg1: argument1,
                arg2: argument2
            )
            
            lowerer.activeLabel.newStatement(tac)
            
            // When we're done, we treat the result as an `RValue`.
            return .stackAllocated(framePointerOffset: resultOffset)
            
        case .call(let pilCall):
            
            // TODO: Calls should be further cleaned up.
            // - We don't need generic `RValues`s for the arguments. They are always declared on the stack, so we should just store their offsets.
            // - There should be more comments here explaining the process.
            
            var loweredArguments: [(name: RValue, size: Int)] = []
            
            // We first calculate each argument and remember their names.
            for argument in pilCall.arguments {
                let name = argument.lowerToTACAsRValue(lowerer, function)
                let words = lowerer.sizeOf(argument.type)
                loweredArguments.append((name, words))
            }
            
            // Then, we declare the variable holding the returned value.
            let returnValueOffset = lowerer.newInternalVariable("call_\(pilCall.name)_retvalue", self.type)
            
            // We keep track of the next argument's position relative to the frame pointer.
            let returnSize = lowerer.sizeOf(lowerer.functions[pilCall.name]!.returnType)
            var argumentOffsetToOldFramePointer = returnValueOffset + returnSize + 2
            
            // Then, since the return value's offset is known, we can push each argument with the correct offset.
            for (name, words) in loweredArguments {
                let statement = TACStatement.pushParameter(value: name, words: words, framePointerOffset: argumentOffsetToOldFramePointer)
                argumentOffsetToOldFramePointer += words
                lowerer.activeLabel.newStatement(statement)
            }
            
            let returnLabel = lowerer.newLabel("\(pilCall.name)_ret", false, function)
            
            let callLabel = lowerer.getFunctionEntryPoint(pilCall.name)
            
            let retType = lowerer.functions[pilCall.name]!.returnType
            let retSize = lowerer.sizeOf(retType)
            
            let callStatement = TACStatement.call(returnValueFramePointerOffset: returnValueOffset, functionLabel: callLabel, returnLabel: returnLabel.name, words: retSize)
            
            lowerer.activeLabel.newStatement(callStatement)
            
            // We switch the active label, so that code resumes not here but at the new location, which is reachable from the callee.
            lowerer.activeLabel = returnLabel
            
            // The result is stored in `lhs`, so we return it so that it is accessible to other statements as well.
            return .stackAllocated(framePointerOffset: returnValueOffset)
            
        case .variable(let name):
            
            // Fetch the variable from the local scope and explicitly cast it as an RValue.
            return lowerer.local.getVariableAsLValue(name).treatAsRValue()
            
        case .integerLiteral(let literal):
            
            // Verify that the integer literal is valid (within bounds). submit an error if it isn't.
            guard let value = Int(literal), 0 <= value, value <= Builtin.intLiteralInclusiveBound else {
                lowerer.submitError(PMaxIssue.illegalIntegerLiteral(literal: literal))
                return .integerLiteral(value: 0)
            }
            
            let variableHoldingLiteralValue = lowerer.newInternalVariable("literal\(value)", .int)
            
            let lValue = LValue.stackAllocated(framePointerOffset: variableHoldingLiteralValue)
            let rValue = RValue.integerLiteral(value: value)
            
            lowerer.activeLabel.newStatement(TACStatement.assign(lhs: lValue, rhs: rValue, words: 1))
            
            return lValue.treatAsRValue()
            
        case .stringLiteral(let literal):
            
            let variableHoldingLiteralValue = lowerer.newInternalVariable("string{\(literal)}", .pointer(pointee: .char))
            
            let lValue = LValue.stackAllocated(framePointerOffset: variableHoldingLiteralValue)
            let rValue = lowerer.getStringLiteralAsRValue(literal)
            
            lowerer.activeLabel.newStatement(TACStatement.assign(lhs: lValue, rhs: rValue, words: 1))
            
            return lValue.treatAsRValue()
            
        case .dereference(let pILExpression):
            
            /// The expression to dereference, lowered to TAC as an `RValue`.
            let argument = pILExpression.lowerToTACAsRValue(lowerer, function)
            
            /// The frame pointer offset of the variable where we store `*argument`.
            let lhsOffset = lowerer.newInternalVariable("dereference", self.type)
            
            /// The `LValue` that holds the dereferenced value.
            let lhs = LValue.stackAllocated(framePointerOffset: lhsOffset)
            
            /// The size (number of words in memory) that the LHS takes up.
            let words = lowerer.sizeOf(self.type)
            
            /// The TAC statement that dereferences the argument and stores it at the new internal variable `lhs`.
            let statement = TACStatement.dereference(
                lhs: lhs,
                expression: argument,
                words: words
            )
            
            lowerer.activeLabel.newStatement(statement)
            
            // Return the dereferenced value, but casted as an RValue.
            return lhs.treatAsRValue()
            
        case .addressOf(let pILExpression):
            
            /// The expression to find the address of, lowered to TAC as an `LValue` (since only `LValue`s have an address).
            let argument = pILExpression.lowerToTACAsLValue(lowerer, function)
            
            /// The offset for a new internal variable which will hold the result of the address-of operation.
            let lhsOffset = lowerer.newInternalVariable("addressOf", self.type)
            
            /// The `LValue` representing the left-hand side of the address-of operation.
            let lhs = LValue.stackAllocated(framePointerOffset: lhsOffset)
            
            /// The TAC statement performing the address-of operation.
            let addressOfStatement = TACStatement.addressOf(
                lhs: lhs,
                expression: argument
            )
            
            lowerer.activeLabel.newStatement(addressOfStatement)
            
            // Treat the result (holding the address of the argument) as an RValue and return it.
            return lhs.treatAsRValue()
            
        case .member(let main, let member):
            
            return lowerToTACAsMemberRValue(main, member, lowerer, function)
            
        case .sizeof(let type):
            
            let size = lowerer.sizeOf(type)
            
            return .integerLiteral(value: size)
            
        }
        
    }
    
    
}
