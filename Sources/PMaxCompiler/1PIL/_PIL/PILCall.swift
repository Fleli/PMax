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
        
    }
    
    var description: String {
        ""
    }
    
}
