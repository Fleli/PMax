enum PILOperation: CustomStringConvertible {
    
    typealias Unary = Expression.SingleArgumentOperator
    typealias Binary = Expression.InfixOperator
    
    case unary(operator: Unary, arg: PILExpression)
    case binary(operator: Binary, arg1: PILExpression, arg2: PILExpression)
    
    /// A `.reference` operation simply points to a nesting of members. The 0th element means a variable in the local scope, the 1st is a member of that variable, the 2nd is a member of that, etc.
    case reference([String])
    
    case call(PILCall)
    
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
        }
    }
    
    func synthesizeType(_ lowerer: PILLowerer) -> PILType {
        
        switch self {
        case .unary(_, _):
            // v1 supports unary operators on `int` only
            return .int
        case .binary(_, _, _):
            // v1 supports binary operators on `int` only
            return .int
        case .reference(let array):
            
            let mainVariable = array[0]
            
            guard let mainType = lowerer.local.getVariable(mainVariable) else {
                // TODO: Submit error
                // We use the `.error` type if the variable does not exist.
                return .error
            }
            
            var type = mainType
            
            for i in 1 ..< array.count {
                let field = array[i]
                type = lowerer.fieldType(field, of: type)
            }
            
            return type
            
        case .call(let pILCall):
            return lowerer.functionType(pILCall.name)
        }
        
    }
    
}
