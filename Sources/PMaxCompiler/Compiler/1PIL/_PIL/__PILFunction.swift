class PILFunction: CustomStringConvertible {
    
    let name: String
    let type: PILType
    var parameters: [PILParameter] = []
    
    let underlyingFunction: Function
    
    var body: PILFunctionBody
    
    var description: String {
        "\(name): \(parameters.map {$0.type}) -> \(type)"
    }
    
    func entryLabelName() -> String {
        switch self.body {
        case .pmax(_, _):
            return "fn_\(name)"
        case .external(_, let entry):
            return entry
        }
    }
    
    var fullDescription: String {
        switch self.body {
        case .pmax(_, let body):
            return
                "\(type) \(name) (\(parameters.description.dropFirst().dropLast())) {\n"
            +   body.reduce("") { $0 + $1.printableDescription(1) }
            +   "}\n"
        case .external(let assembly, _):
            return assembly
        }
            
    }
    
    
    /// Initialize a `PILFunction` from an underlying (syntactical) `Function` object.
    convenience init(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        let body = PILFunctionBody.pmax(underlyingFunction: underlyingFunction, lowered: [])
        self.init(underlyingFunction, body, lowerer)
    }
    
    
    /// Initialize a `PILFunction` from an external function object (a function imported from a library). The `underlyingExternalFunction` is used to build the function's signature: its `type`, `name` and `parameters`. The `body` of an external function is its corresponding assembly code. `entry` is the label to jump to when calling the function.
    convenience init(_ underlyingExternalFunction: Function, _ body: String, _ entry: String, _ lowerer: PILLowerer) {
        let body = PILFunctionBody.external(assembly: body, entry: entry)
        self.init(underlyingExternalFunction, body, lowerer)
    }
    
    
    private init(_ underlyingFunction: Function, _ body: PILFunctionBody, _ lowerer: PILLowerer) {
        
        self.name = underlyingFunction.name
        self.type = PILType(underlyingFunction.returnType, lowerer)
        
        self.body = body
        
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
        
        guard case .pmax(let underlyingFunction, var loweredBody) = body else {
            return
        }
        
        lowerer.push()
        
        // We declare each parameter in the function scope.
        for parameter in parameters {
            lowerer.local.declare(parameter.type, parameter.label)
        }
        
        // Then we lower the function's body.
        for statement in underlyingFunction.body {
            loweredBody += statement.lowerToPIL(lowerer)
        }
        
        lowerer.pop()
        
        self.body = .pmax(underlyingFunction: underlyingFunction, lowered: loweredBody)
        
        verifyReturns(lowerer)
        
    }
    
    func verifyReturns(_ lowerer: PILLowerer) {
        
        guard case .pmax(let underlyingFunction, var lowered) = body else {
            return
        }
        
        let returnsOnAllPaths = lowered.reduce(false, {$0 || $1.returnsOnAllPaths(type, lowerer)})
        
        if returnsOnAllPaths {
            return
        }
        
        if type == .void {
            
            let insertedReturn = PILStatement.return(expression: nil)
            lowered.append(insertedReturn)
            
        } else {
            
            lowerer.submitError(PMaxIssue.doesNotReturnOnAllPaths(function: name))
            
        }
        
        self.body = .pmax(underlyingFunction: underlyingFunction, lowered: lowered)
        
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
