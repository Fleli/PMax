enum TACStatement: CustomStringConvertible {
    
    typealias Binary = Expression.InfixOperator
    typealias Unary = Expression.SingleArgumentOperator
    
    /// Assign the result of the operation `arg1 (op) arg2` to `lhs`.
    case assignBinaryOperation(lhs: LValue, operation: Binary, arg1: RValue, arg2: RValue)
    
    /// Assign the result of the operation `(op) arg` to `lhs`.
    case assignUnaryOperation(lhs: LValue, operation: Unary, arg: RValue)
    
    /// Jump to a label in named `label`.
    case jump(label: String)
    
    /// Jump to a label named `label` if the `RValue` condition is non-zero
    case jumpIfNonZero(label: String, condition: RValue)
    
    /// Call a function whose start label is `functionLabel` and return to `returnLabel`. The returned result is `words` words long and is assigned to the given frame pointer offset.
    case call(returnValueFramePointerOffset: Int, functionLabel: String, returnLabel: String, words: Int)
    
    /// Push a parameter `value` of size `words` at an offset of `framePointerOffset` from the current function's frame pointer.
    case pushParameter(value: RValue, words: Int, framePointerOffset: Int)
    
    /// Assign the value of dereferencing `expression` to the location `lhs`. The `words` integer is used to find the number of words to copy (the size of the type being assigned to `lhs`).
    case dereference(lhs: LValue, expression: RValue, words: Int)
    
    /// Find the address of `expression`. Addresses only exist for `LValue`s. The address is assigned to `lhs`.
    case addressOf(lhs: LValue, expression: LValue)
    
    /// Assign the value at `rhs` to the location `lhs`. The `words` attribute tells how large the value to copy is (e.g. whether to copy 1, 2, 3, etc. words). The `lhs` and `rhs` locations represent the _start_ addresses to use.
    case assign(lhs: LValue, rhs: RValue, words: Int)
    
    /// Return a value from a function. If the function is `void`, the `returnValueFramePointerOffset` is `nil` and `words` is `0` (indicating the length of the return value is 0).
    /// For non-`void` functions, the `returnValueFramePointerOffset` specifies the beginning frame pointer offset of the return value, and `words` indicates the return value's size.
    case `return`(returnValueFramePointerOffset: Int?, words: Int)
    
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
        case .return(nil, let words):
            return "[\(words)]  ret void)"
        case .return(let value, let words):
            return "[\(words)]  ret [fp + \(value!)]"
        }
        
    }
    
}
