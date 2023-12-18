enum TACStatement: CustomStringConvertible {
    
    typealias Binary = Expression.InfixOperator
    typealias Unary = Expression.SingleArgumentOperator
    
    /// Assign the result of the operation `arg1 (op) arg2` to `lhs` for values in arbitrary locations `lhs`, `arg1`, `arg2`.
    case assignBinaryOperation(lhs: Location, operation: Binary, arg1: Location, arg2: Location)
    
    /// Assign the result of the operation `(op) arg` to `lhs` for values in arbitrary locations `lhs`, `arg`.
    case assignUnaryOperation(lhs: Location, operation: Unary, arg: Location)
    
    /// Jump to a label in named `label`.
    case jump(label: String)
    
    /// Jump to a label named `label` if the value at location `variable` is non-zero.
    case jumpIfNonZero(label: String, variable: Location)
    
    /// Call a function whose start label is `functionLabel` and return to `returnLabel`. The returned result is `words` words long and is assigned to `lhs`, which is assumed to be a frame pointer offset.
    case call(lhs: Location, functionLabel: String, returnLabel: String, words: Int)
    
    /// Push a parameter of size `words` at an offset of `framePointerOffset` from the current function's frame pointer. The value to push is found at `at`.
    case pushParameter(at: Location, words: Int, framePointerOffset: Int)
    
    /// Assign the value of dereferencing `arg` to the location `lhs`. The `words` integer is used to find the number of words to copy (the size of the type being assigned to `lhs`).
    case dereference(lhs: Location, arg: Location, words: Int)
    
    /// Find the address of the variable referred to by `arg`. Assign this address to `lhs`.
    case addressOf(lhs: Location, arg: Location)
    
    /// Assign the value at `rhs` to the location `lhs`. The `words` attribute tells how large the value to copy is (e.g. whether to copy 1, 2, 3, etc. words). The `lhs` and `rhs` locations represent the _start_ addresses to use.
    case assign(lhs: Location, rhs: Location, words: Int)
    
    /// Return from a function. The return value is an optional `Location` (which is `nil` for `void` returns and non-`nil` otherwise). `words` tells the size of the value to return.
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
            return "[\(words)]  \(lhs) = call \(function), resume \(returnLabel)"
        case .pushParameter(let name, let words, let framePointerOffset):
            return "[\(words)]  param \(name) @ fp + \(framePointerOffset)"
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
