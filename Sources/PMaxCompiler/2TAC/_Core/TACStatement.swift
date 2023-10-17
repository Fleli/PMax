enum TACStatement: CustomStringConvertible {
    
    typealias Binary = Expression.InfixOperator
    typealias Unary = Expression.SingleArgumentOperator
    
    case assignBinaryOperation(lhs: String, operation: Binary, arg1: String, arg2: String)
    case assignUnaryOperation(lhs: String, operation: Unary, arg: String)
    
    case jump(label: String)
    case jumpIfNonZero(label: String, variable: String)
    
    case call(lhs: String, function: String, returnLabel: String)
    case pushParameter(name: String)
    
    case dereference(lhs: String, arg: String)
    case addressOf(lhs: String, arg: String)
    
    case member(lhs: String, rhsMain: String, rhsMember: String)
    
    case `return`(value: String?)
    
    var description: String {
        
        switch self {
        case .assignBinaryOperation(let lhs, let operation, let arg1, let arg2):
            return lhs + " = " + arg1 + " \(operation.rawValue) " + arg2
        case .assignUnaryOperation(let lhs, let operation, let arg):
            return lhs + " = " + " \(operation.rawValue) " + arg
        case .jump(let label):
            return "jump \(label)"
        case .jumpIfNonZero(let label, let variable):
            return "jump \(label) if \(variable) != 0"
        case .call(let lhs, let function, let returnLabel):
            return "\(lhs) = call to \(function) - continue at \(returnLabel)"
        case .pushParameter(let name):
            return "param \(name)"
        case .dereference(let lhs, let arg):
            return lhs + " = *\(arg)"
        case .addressOf(let lhs, let arg):
            return lhs + " = &\(arg)"
        case .member(let lhs, let rhsMain, let rhsMember):
            return "\(lhs) = \(rhsMain).\(rhsMember)"
        case .return(let value):
            return "ret \(value ?? "[void]")"
        }
        
    }
    
}
