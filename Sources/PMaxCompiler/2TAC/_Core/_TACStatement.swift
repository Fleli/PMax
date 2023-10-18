enum TACStatement: CustomStringConvertible {
    
    typealias Binary = Expression.InfixOperator
    typealias Unary = Expression.SingleArgumentOperator
    
    case assignBinaryOperation(lhs: Location, operation: Binary, arg1: Location, arg2: Location)
    case assignUnaryOperation(lhs: Location, operation: Unary, arg: Location)
    
    case jump(label: String)
    case jumpIfNonZero(label: String, variable: Location)
    
    case call(lhs: Location, function: String, returnLabel: String)
    case pushParameter(at: Location)
    
    case dereference(lhs: Location, arg: Location)
    case addressOf(lhs: Location, arg: Location)
    
    case simpleAssign(lhs: Location, rhs: Location)
    
    case `return`(value: Location?)
    
    var description: String {
        
        switch self {
        case .assignBinaryOperation(let lhs, let operation, let arg1, let arg2):
            return "\(lhs) = \(arg1) \(operation.rawValue) \(arg2)"
        case .assignUnaryOperation(let lhs, let operation, let arg):
            return "\(lhs) = " + " \(operation.rawValue) \(arg)"
        case .jump(let label):
            return "jump \(label)"
        case .jumpIfNonZero(let label, let variable):
            return "jump \(label) if \(variable) != 0"
        case .call(let lhs, let function, let returnLabel):
            return "\(lhs) = call to \(function) - continue at \(returnLabel)"
        case .pushParameter(let name):
            return "param \(name)"
        case .dereference(let lhs, let arg):
            return "\(lhs) = *\(arg)"
        case .addressOf(let lhs, let arg):
            return "\(lhs) = &\(arg)"
        case .simpleAssign(let lhs, let rhs):
            return "\(lhs) = \(rhs)"
        case .return(let value):
            return "ret \(value?.description ?? "[void]")"
        }
        
    }
    
}
