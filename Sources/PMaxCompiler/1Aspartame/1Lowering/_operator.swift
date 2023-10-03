extension Aspartame {
    
    internal func convertInfixToCall(_ operation: String, lhs: String, rhs: String) -> LoweredExpression {
        
        // Function name that is internal to the compiler, used only operators.
        let functionName = "$infix\(operation)"
        
        let tmp = newInternalVariable()
        let newDecl = tmp.statement
        let assign = AspartameStatement.assignFromCall(lhs: tmp.name, function: functionName, arguments: [lhs, rhs])
        
        let statements = [newDecl, assign]
        
        return LoweredExpression(tmp.name, statements)
        
    }
    
    internal func convertUnaryToCall(_ operation: String, lhs: String) -> LoweredExpression {
        
        // Function name that is internal to the compiler, used only operators.
        let functionName = "$unary\(operation)"
        
        let tmp = newInternalVariable()
        let newDecl = tmp.statement
        let assign = AspartameStatement.assignFromCall(lhs: tmp.name, function: functionName, arguments: [lhs])
        
        let statements = [newDecl, assign]
        
        return LoweredExpression(tmp.name, statements)
        
    }
    
}
