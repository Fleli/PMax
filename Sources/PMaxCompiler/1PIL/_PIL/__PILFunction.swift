class PILFunction: CustomStringConvertible {
    
    let name: String
    let type: PILType
    var parameters: [PILParameter] = []
    
    var body: [PILStatement] = []
    
    var description: String {
        "PILFunction \(name): \(parameters.map {$0.type}) -> \(type)"
    }
    
    let underlyingFunction: Function
    
    /// Initialize a `PILFunction` from an underlying (syntactical) `Function` object. This includes lowering all statements within the function to their `PIL` equivalent.
    init(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        self.name = underlyingFunction.name
        self.type = PILType(underlyingFunction.returnType, lowerer)
        
        self.underlyingFunction = underlyingFunction
        
        appendParameters(underlyingFunction, lowerer)
        
    }
    
    private func appendParameters(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        for parameter in underlyingFunction.parameters {
            
            /// We store each parameter in the `parameters` array
            let type = PILType(parameter.type, lowerer)
            let newParameter = PILParameter(type, parameter.name)
            self.parameters.append(newParameter)
            
        }
        
    }
    
    func lowerToPIL(_ lowerer: PILLowerer) {
        
        lowerer.push()
        
        // We declare each parameter in the function scope.
        for parameter in parameters {
            lowerer.local.declare(parameter.type, parameter.label)
        }
        
        // Then we lower the function's body.
        for statement in underlyingFunction.body {
            let lowered = statement.lowerToPIL(lowerer)
            self.body += lowered
        }
        
        lowerer.pop()
        
    }
    
    struct PILParameter {
        
        let type: PILType
        let label: String
        
        init(_ type: PILType, _ label: String) {
            self.type = type
            self.label = label
        }
        
    }
    
}
