class PILFunction: CustomStringConvertible {
    
    // TODO: Stored Variables
    
    /// The name of the function.
    let name: String
    
    /// The type of the function's parameter list, either `void`, `A` or `(A1, ..., An)`
    var parameterType: PILType!
    
    /// The return type of the function.
    let returnType: PILType
    
    /// An array of the function's parameters.
    /// Each parameter is a `PILParameter`, holding type and name.
    var parameters: [PILParameter] = []
    
    // TODO: Is it necessary to explicitly store this?
    /// The underlying syntactical `Function` object.
    let underlyingFunction: Function
    
    /// The function's body of type `PILFunctionBody`.
    /// A function body is expressed either in terms of `.pmax` source code with an underlying syntactical `Function`, or as an `.external` case for imported libraries, in which case only the function's assembly code and entry point is available.
    var body: PILFunctionBody
    
    // MARK: Computed Variables
    
    /// A description of the function on the form `N: P -> R` for name `N`, parameters `P` and return type `R`.
    var description: String {
        "\(name): \(parameters.map {$0.type}) -> \(returnType)"
    }
    
    /// Reconstruct the function's signature on the form `T N ( Args )` for return type `T`, function name `N` and argument list `Args`.
    var signature: String {
        "func " + name + "(" + parameters.listForm(", ") + ")" + " -> " + returnType.description
    }
    
    /// The name of the function's entry label (in assembly code).
    /// The entry label name is derived from the function name: `@fn_name` for function name `name`.
    var entryLabelName: String {
        
        switch self.body {
            
        case .pmax(_, _):
            return "fn_\(name)"
        case .external(_, let entry):
            return entry
        }
        
    }
    
    /// Return a full description of the function, not just the signature or metadata.
    /// A full description includes the function body.
    /// External (imported) functions are simply described as `[extern] E` for entry label `E` since their corresponding PIL representation is lost.
    var fullDescription: String {
        
        switch self.body {
            
        case .pmax(_, let body):
            return
                "\(returnType) \(name) (\(parameters.description.dropFirst().dropLast())) {\n"
            +   body.reduce("") { $0 + $1.printableDescription(1) }
            +   "}\n"
        case .external(_, let entry):
            return "[extern] \(entry)\n"
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
    
    /// This is `PILFunction`'s only designated initializer, and is used both for internally and externally defined functions.
    /// Initializes a `PILFunction` from an underlying `Function`, a `PILFunctionBody` and a `PILLowerer`.
    private init(_ underlyingFunction: Function, _ body: PILFunctionBody, _ lowerer: PILLowerer) {
        
        // Set the name and return type of the function.
        self.name = underlyingFunction.name
        self.returnType = PILType(underlyingFunction.returnType, lowerer)
        
        // Initialize the body and underlying function
        self.body = body
        self.underlyingFunction = underlyingFunction
        
        // Set all the function's parameters.
        initializeParameters(underlyingFunction, lowerer)
        
    }
    
    /// Go through each parameter of the underlying function and convert it to PIL form.
    /// This function makes sure all the function's parameters are set appropriately.
    private func initializeParameters(_ underlyingFunction: Function, _ lowerer: PILLowerer) {
        
        // Map each underlying function parameter to the corresponding PIL parameter.
        self.parameters = underlyingFunction.parameters
            .map { PILParameter( PILType($0.type, lowerer), $0.name) }
        
        // Register the parameter tuple in the associated `PILLowerer`
        let tuple = `Type`.tuple("(", underlyingFunction.parameters.map { $0.type }, ")")
        self.parameterType = PILType(tuple, lowerer)
        
    }
    
    /// Lower the function body to PIL.
    /// This function goes walks the statement tree, lowering each statement to PIL.
    func lowerToPIL(_ lowerer: PILLowerer) {
        
        // External functions (imported through libraries) are already in assembly form.
        // Therefore, lowering them to PIL makes no sense.
        guard case .pmax(let underlyingFunction, var loweredBody) = body else {
            return
        }
        
        // Since we enter the function body (we're in-between {}), we push a new local scope.
        lowerer.push()
        
        // We declare each parameter in the function scope.
        for parameter in parameters {
            lowerer.local.declare(parameter.type, parameter.label)
        }
        
        // Then we lower the function's body.
        for statement in underlyingFunction.body {
            loweredBody += statement.lowerToPIL(lowerer)
        }
        
        // After lowering, we pop the function's scope, meaning we're back to the global scope.
        lowerer.pop()
        
        // Then, we update the function's `body` property to include the new (lowered) body
        self.body = .pmax(underlyingFunction: underlyingFunction, lowered: loweredBody)
        
        // Finally, we verify that the function returns on all paths (and checks that types are correct).
        verifyReturns(lowerer)
        
    }
    
    func verifyReturns(_ lowerer: PILLowerer) {
        
        // If the function is external (within a library), it is assumed that its semantics are already verified.
        guard case .pmax(let underlyingFunction, var lowered) = body else {
            return
        }
        
        let returnsOnAllPaths = lowered.reduce(false, {$0 || $1.returnsOnAllPaths(returnType, lowerer)})
        
        if returnsOnAllPaths {
            return
        }
        
        if returnType == .void {
            
            let insertedReturn = PILStatement.return(expression: nil)
            lowered.append(insertedReturn)
            
        } else {
            
            lowerer.submitError(PMaxIssue.doesNotReturnOnAllPaths(function: name))
            
        }
        
        self.body = .pmax(underlyingFunction: underlyingFunction, lowered: lowered)
        
    }
    
    /// The (function) type of this function, `params -> ret`
    func type(with lowerer: PILLowerer) -> PILType {
        return PILType.function(input: parameterType, output: returnType)
    }
    
    struct PILParameter: CustomStringConvertible {
        
        let type: PILType
        let label: String
        
        var description: String {
            label + ": " + type.description
        }
        
        init(_ type: PILType, _ label: String) {
            self.type = type
            self.label = label
        }
        
    }
    
}

extension Array where Element: CustomStringConvertible {
    
    func listForm(_ separator: String = ", ") -> String {
        
        if count == 0 {
            return ""
        }
        
        let list = reduce("") { $0 + $1.description + separator }.dropLast(separator.count)
        
        return String(list)
        
    }
    
}
