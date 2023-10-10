class PILFunction: CustomStringConvertible {
    
    let name: String
    let type: PILType
    let parameters: [PILParameter]
    
    var description: String {
        "PILFunction \(name):  \t\(parameters.map {$0.type}) -> \(type)"
    }
    
    init(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        self.name = underlyingFunction.name
        self.type = PILType(underlyingFunction.returnType, lowerer)
        
        var params: [PILParameter] = []
        
        for parameter in underlyingFunction.parameters {
            let label = parameter.name
            let type = PILType(parameter.type, lowerer)
            let pilParamerer = PILParameter(type, label)
            params.append(pilParamerer)
        }
        
        self.parameters = params
        
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
