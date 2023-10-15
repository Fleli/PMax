enum PILOperation: CustomStringConvertible {
    
    typealias Unary = Expression.SingleArgumentOperator
    typealias Binary = Expression.InfixOperator
    
    case unary(operator: Unary, arg: PILExpression)
    case binary(operator: Binary, arg1: PILExpression, arg2: PILExpression)
    
    case call(PILCall)
    
    /// Use the `variable` case when we try to access a variable, either local or global.
    case variable(String)
    
    case dereference(PILExpression)
    
    case addressOf(PILExpression)
    
    /// The `member` operation involves finding a member of another (struct-type) variable.
    case member(main: PILExpression, member: String)
    
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
        case .dereference(let arg):
            return "(*\(arg))"
        case .addressOf(let arg):
            return "(&\(arg))"
        case .member(let main, let member):
            return "((\(main)).\(member))"
        }
    }
    
    func synthesizeType(_ lowerer: PILLowerer) -> PILType {
        
        switch self {
        case .unary(let `operator`, let arg):
            
            guard case .int = arg.type else {
                lowerer.submitError(.unaryOperatorNotDefined(op: `operator`.rawValue, argType: arg.type))
                return .error
            }
            
            return .int
            
        case .binary(let `operator`, let arg1, let arg2):
            
            guard case .int = arg1.type, case .int = arg2.type else {
                lowerer.submitError(.binaryOperatorNotDefined(op: `operator`.rawValue, arg1Type: arg1.type, arg2Type: arg2.type))
                return .error
            }
            
            return .int
            
        case .call(let pILCall):
            
            let funcType = lowerer.functionType(pILCall.name)
            
            if funcType == .error {
                lowerer.submitError(.functionDoesNotExist(name: pILCall.name))
            }
            
            return funcType
            
        case .variable(let variable):
            
            guard let type = lowerer.local.getVariable(variable) else {
                lowerer.submitError(.variableIsNotDeclared(name: variable))
                return .error
            }
            
            return type
            
        case .dereference(let expression):
            
            // Not implemented
            fatalError()
            
        case .addressOf(let expression):
            
            // Not implemented
            fatalError()
            
        case .member(let main, let member):
            
            return lowerer.fieldType(member, of: main.type)
            
        }
        
    }
    
}
