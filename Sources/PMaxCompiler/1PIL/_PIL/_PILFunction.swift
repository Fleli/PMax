class PILFunction: CustomStringConvertible {
    
    let name: String
    let type: PILType
    var parameters: [PILParameter] = []
    
    var body: [PILStatement] = []
    
    var description: String {
        "PILFunction \(name):  \t\(parameters.map {$0.type}) -> \(type)"
    }
    
    /// Initialize a `PILFunction` from an underlying (syntactical) `Function` object. This includes lowering all statements within the function to their `PIL` equivalent.
    init(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        self.name = underlyingFunction.name
        self.type = PILType(underlyingFunction.returnType, lowerer)
        
        appendParameters(underlyingFunction, lowerer)
        
        lowerToPIL(underlyingFunction, lowerer)
        
    }
    
    private func appendParameters(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        for parameter in underlyingFunction.parameters {
            let type = PILType(parameter.type, lowerer)
            let newParameter = PILParameter(type, parameter.name)
            self.parameters.append(newParameter)
        }
        
    }
    
    private func lowerToPIL(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        for statement in underlyingFunction.body {
            
        }
        
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
