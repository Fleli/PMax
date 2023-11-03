class PILCall: CustomStringConvertible {
    
    let name: String
    let arguments: [PILExpression]
    
    init(_ name: String, _ arguments: Arguments, _ lowerer: PILLowerer) {
        
        self.name = name
        
        var args: [PILExpression] = []
        
        for arg in arguments {
            let loweredExpression = arg.expression.lowerToPIL(lowerer)
            args.append(loweredExpression)
        }
        
        self.arguments = args
        
        performSemanticChecksOnArguments(lowerer)
        
    }
    
    private func performSemanticChecksOnArguments(_ lowerer: PILLowerer) {
        
        guard let function = lowerer.functions[name] else {
            // TODO: Verify that we should actually submit an error here. We probably shouldn't.
            lowerer.submitError(PMaxIssue.functionDoesNotExist(name: name))
            return
        }
        
        let argumentCount = self.arguments.count
        let parameterCount = function.parameters.count
        
        guard argumentCount == parameterCount else {
            lowerer.submitError(PMaxIssue.incorrectNumberOfArguments(functionName: name, expected: parameterCount, given: argumentCount))
            return
        }
        
        for i in 0 ..< argumentCount {
            
            let argumentType = self.arguments[i].type
            let parameterType = function.parameters[i].type
            
            guard argumentType == parameterType else {
                lowerer.submitError(PMaxIssue.incorrectTypeInFunctionCall(functionName: name, expected: parameterType, given: argumentType, position: i + 1))
                continue
            }
            
            // TODO: Verify that there is nothing more to check.
            
        }
        
    }
    
    var description: String {
        "\(name) (\(arguments.reduce("", {$0 + $1.description + ", "})))"
    }
    
}
