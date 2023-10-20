enum TACStatement: CustomStringConvertible {
    
    typealias Binary = Expression.InfixOperator
    typealias Unary = Expression.SingleArgumentOperator
    
    case assignBinaryOperation(lhs: Location, operation: Binary, arg1: Location, arg2: Location)
    case assignUnaryOperation(lhs: Location, operation: Unary, arg: Location)
    
    case jump(label: String)
    case jumpIfNonZero(label: String, variable: Location)
    
    case call(lhs: Location, function: String, returnLabel: String, words: Int)
    case pushParameter(at: Location, words: Int)
    
    case dereference(lhs: Location, arg: Location, words: Int)
    case addressOf(lhs: Location, arg: Location)
    
    /// A `.assign` represents an assignment from one location to another.
    case assign(lhs: Location, rhs: Location, words: Int)
    
    case `return`(value: Location?, words: Int)
    
    var description: String {
        
        switch self {
        case .assignBinaryOperation(let lhs, let operation, let arg1, let arg2):
            return "\t \(lhs) = \(arg1) \(operation.rawValue) \(arg2)"
        case .assignUnaryOperation(let lhs, let operation, let arg):
            return "\t \(lhs) = " + " \(operation.rawValue) \(arg)"
        case .jump(let label):
            return "jump \(label)"
        case .jumpIfNonZero(let label, let variable):
            return "jump \(label) if \(variable) != 0"
        case .call(let lhs, let function, let returnLabel, let words):
            return "[\(words)]  \(lhs) = call \(function) - resume @ \(returnLabel)"
        case .pushParameter(let name, let words): // TODO: We may need to specify a number of words here.
            return "[\(words)]  param \(name)"
        case .dereference(let lhs, let arg, let words):
            return "[\(words)]  \(lhs) = *\(arg)"
        case .addressOf(let lhs, let arg):
            return "\t \(lhs) = &\(arg)"
        case .assign(let lhs, let rhs, let words):
            return "[\(words)]  \(lhs) = \(rhs)"
        case .return(let value, let words):
            return "[\(words)]  ret \(value?.description ?? "[void]")"
        }
        
    }
    
}
