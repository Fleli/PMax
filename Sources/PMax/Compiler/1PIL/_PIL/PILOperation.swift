enum PILOperation: CustomStringConvertible {
    
    typealias Unary = Expression.SingleArgumentOperator
    typealias Binary = Expression.InfixOperator
    
    case unary(operator: Unary, arg: PILExpression)
    case binary(operator: Binary, arg1: PILExpression, arg2: PILExpression)
    
    case call(PILCall)
    
    case variable(String)
    
    case integerLiteral(String)
    
    case stringLiteral(String)
    
    case dereference(PILExpression)
    
    case addressOf(PILExpression)
    
    /// The `member` operation involves finding a member of another (struct-type) variable.
    case member(main: PILExpression, member: String)
    
    case sizeof(type: PILType)
    
    var description: String {
        
        switch self {
            
        case .unary(let `operator`, let arg):
            return "(\(`operator`.rawValue)\(arg.description))"
        case .binary(let `operator`, let arg1, let arg2):
            return "(\(arg1.description)\(`operator`.rawValue)\(arg2.description))"
        case .call(let call):
            return call.description
        case .variable(let variable):
            return variable
        case .integerLiteral(let literal):
            return literal
        case .stringLiteral(let str):
            return "\"\(str)\""
        case .dereference(let arg):
            return "(*\(arg))"
        case .addressOf(let arg):
            return "(&\(arg))"
        case .member(let main, let member):
            return "((\(main)).\(member))"
        case .sizeof(let type):
            return "sizeof(\(type.description))"
        }
        
    }
    
    var readableDescription: String {
        
        switch self {
            
        case .unary(let `operator`, let arg):
            return "(\(`operator`.rawValue)\(arg.readableDescription))"
        case .binary(let `operator`, let arg1, let arg2):
            return "(\(arg1.readableDescription)\(`operator`.rawValue)\(arg2.readableDescription))"
        case .call(let pILCall):
            return "\(pILCall.name)(\(pILCall.arguments.reduce("", {$0 + $1.readableDescription}).dropFirst().dropLast()))"
        case .variable(let string):
            
            if string.contains("literal=") {
                return String(string.dropFirst("literal=".count))
            }
            
            return string
            
        case .integerLiteral(let literal):
            return literal
        case .stringLiteral(_):
            return description
        case .dereference(let pILExpression):
            return "*\(pILExpression.readableDescription)"
        case .addressOf(let pILExpression):
            return "&\(pILExpression.readableDescription)"
        case .member(let main, let member):
            return "(\(main.readableDescription)).\(member)"
        case .sizeof(let type):
            return "sizeof(\(type.description))"
        }
        
    }
    
}
