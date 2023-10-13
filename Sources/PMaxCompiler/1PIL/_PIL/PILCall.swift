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
        
        // TODO: Må vi type-checke argumentene her?
        
        self.arguments = args
        
    }
    
    var description: String {
        "\(name) (\(arguments.reduce("", {$0 + $1.description + ", "})))"
    }
    
}
