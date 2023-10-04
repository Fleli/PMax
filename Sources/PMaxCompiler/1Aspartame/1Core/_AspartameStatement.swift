enum AspartameStatement {
    
    /// Declare that the variable `name` of type `type` should be recognized and exist within the current block.
    case declaration(name: String, type: DataType)
    
    /// Assign the value of `rhs` to `lhs`
    case assignment(lhs: String, rhs: String)
    
    // TODO: Follow this up.
    /// Integer literals are still stored as strings because further semantic checks (bounds etc.) are checked later
    case assignIntegerLiteral(lhs: String, literal: String)
    
    /// Used if we have a reference `r` and want to access a member `m`, and store this in `s` using dot syntax `s = r.m`.
    case accessMember(lhs: String, rhs: String, member: String)
    
    /// Assign the returned value from calling `function` to `lhs`. The call's `argmuents` are all references to variables that may be the result of a computation.
    case assignFromCall(lhs: String, function: String, arguments: [String])
    
    /// Introduce a new block whenever we enter a body of statements, for example an `if` or `while`.
    case block(statements: [AspartameStatement])
    
    /// If the `check` variable stores a bitpattern equal to `0`, we skip the next `n` `AspartameStatement`s in the enclosing sequence. This is essentially a branch.
    case ignoreNextIfZero(check: String, n: Int)
    
    /// Unconditionally jump back `n` `AspartameStatement`s in the enclosing sequence.
    case jumpBack(n: Int)
    
    /// The `return` case is used for representing `return` statements. Its `value` is either a `string` (if it returns the value of an identifier) or `nil` if the statement is simply `return;`.
    case `return`(value: String?)
    
    
    func _print(indent: Int) {
        
        let prefix = String(repeating: "|   ", count: indent)
        print(prefix, terminator: "")
        
        switch self {
        case .declaration(let name, let type):
            print(type.description + " " + name)
        case .assignment(let lhs, let rhs):
            print(lhs + " = " + rhs)
        case .assignIntegerLiteral(let lhs, let literal):
            print(lhs + " = " + literal)
        case .accessMember(let lhs, let rhs, let member):
            print(lhs + " = " + rhs + "." + member)
        case .assignFromCall(let lhs, let function, let arguments):
            print(lhs + " = " + function + "(\(arguments.description.dropFirst().dropLast()))")
        case .block(let statements):
            print("{")
            for statement in statements {
                statement._print(indent: indent + 1)
            }
            print(prefix + "}")
        case .ignoreNextIfZero(let check, let n):
            print("Ignore next \(n) if \(check) == 0")
        case .jumpBack(let n):
            print("Jump back \(n)")
        case .return(let value):
            print("return \(value ?? ";")")
        }
        
    }
    
    
}

