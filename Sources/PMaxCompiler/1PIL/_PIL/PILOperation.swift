enum PILOperation: CustomStringConvertible {
    
    typealias Unary = Expression.SingleArgumentOperator
    typealias Binary = Expression.InfixOperator
    
    case unary(operator: Unary, arg: PILExpression)
    case binary(operator: Binary, arg1: PILExpression, arg2: PILExpression)
    
    // TODO: Find out how dereferencing (*x) is going to work.
    
    /// A `.reference` operation simply points to a nesting of members. The 0th element means a variable in the local scope, the 1st is a member of that variable, the 2nd is a member of that, etc.
    case reference([String])
    
    case call(PILCall)
    
    case dereference(PILExpression)
    case addressOf([String])
    
    var description: String {
        switch self {
        case .unary(let `operator`, let arg):
            return "(\(`operator`.rawValue)\(arg.description))"
        case .binary(let `operator`, let arg1, let arg2):
            return "(\(arg1.description)\(`operator`.rawValue)\(arg2.description))"
        case .reference(let array):
            return "\(array.reduce("", {$0 + $1 + "."}).dropLast())"
        case .call(let call):
            return call.description
        case .dereference(let arg):
            return "(*\(arg))"
        case .addressOf(let array):
            return "(&\(array.reduce("", {$0 + $1 + "."}).dropLast()))"
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
            
        case .reference(let array):
            
            let mainVariable = array[0]
            
            guard let mainType = lowerer.local.getVariable(mainVariable) else {
                lowerer.submitError(.variableIsNotDeclared(name: mainVariable))
                return .error
            }
            
            var type = mainType
            
            for i in 1 ..< array.count {
                let field = array[i]
                type = lowerer.fieldType(field, of: type)
            }
            
            return type
            
        case .call(let pILCall):
            
            let funcType = lowerer.functionType(pILCall.name)
            
            if funcType == .error {
                lowerer.submitError(.functionDoesNotExist(name: pILCall.name))
            }
            
            return funcType
            
        case .dereference(let expression):
            
            let expressionType = expression.type
            
            guard case .pointer(let pointee) = expressionType else {
                lowerer.submitError(.dereferenceNonPointerType(type: expressionType))
                return .error
            }
            
            return pointee
            
        case .addressOf(let array):
            
            let reference = PILOperation.reference(array)
            let type = reference.synthesizeType(lowerer)
            return .pointer(pointee: type)
            
        }
        
    }
    
}
