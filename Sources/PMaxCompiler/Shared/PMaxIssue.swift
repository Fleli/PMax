enum PMaxIssue: PMaxError {
    
    case cannotFindMemberOfNonStructType(member: String, type: PILType)
    case typeDoesNotExist(typeName: String)
    case fieldDoesNotExist(structName: String, field: String)
    case redeclarationOfField(structName: String, field: String)
    case assignmentTypeMismatch(lhs: PILExpression, actual: PILType)
    case redeclarationOfVariable(varName: String, existing: PILType, new: PILType)
    case variableIsNotDeclared(name: String)
    case unaryOperatorNotDefined(op: String, argType: PILType)
    case binaryOperatorNotDefined(op: String, arg1Type: PILType, arg2Type: PILType)
    case functionDoesNotExist(name: String)
    case structMembersCannotHaveDefaultValues(structName: String, field: String)
    case incorrectNumberOfArguments(functionName: String, expected: Int, given: Int)
    case incorrectTypeInFunctionCall(functionName: String, expected: PILType, given: PILType, position: Int)
    case dereferenceNonPointerType(type: PILType)
    case cannotFindAddressOfNonReference
    case invalidSugaredAssignment(`operator`: String)
    case incorrectReturnType(expected: PILType, given: PILType)
    case doesNotReturnOnAllPaths(function: String)
    case structIsRecursive(structName: String)
    case unassignableLHS(lhs: PILExpression)
    case hasNoValidMain
    case invalidMember(invalid: PILExpression)
    case grammaticalIssue(description: String)
    case illegalIntegerLiteral(literal: String)
    
    var allowed: Bool {
        false
    }
    
    var description: String {
        "[issue]  \t" + {
            switch self {
            case .cannotFindMemberOfNonStructType(let member, let type):
                return "Cannot find member '\(member)' of non-struct type '\(type)'."
            case .typeDoesNotExist(let typeName):
                return "The type '\(typeName)' does not exist."
            case .fieldDoesNotExist(let structName, let field):
                return "The property '\(field)' does not exist on '\(structName)'."
            case .redeclarationOfField(let structName, let field):
                return "Redeclaration of field '\(field)' on struct '\(structName)'."
            case .assignmentTypeMismatch(let expression, let actual):
                return "Cannot assign value of type '\(actual)' to '\(expression.readableDescription)' of type '\(expression.type)'."
            case .redeclarationOfVariable(let varName, let existing, let new):
                return "The variable '\(existing) \(varName)' is already declared within this scope, so '\(new) \(varName)' cannot be declared."
            case .variableIsNotDeclared(let name):
                return "The variable '\(name)' is not declared in this or any of its enclosing scopes."
            case .unaryOperatorNotDefined(let op, let argType):
                return "The unary operator '\(op)' is not defined on operand of type '\(argType)'."
            case .binaryOperatorNotDefined(let op, let arg1Type, let arg2Type):
                return "The binary operator '\(op)' is not defined on operands of types '\(arg1Type)' and '\(arg2Type)'."
            case .functionDoesNotExist(let name):
                return "The function '\(name)' is not defined."
            case .structMembersCannotHaveDefaultValues(let structName, let field):
                return "Member '\(field)' of struct '\(structName)' cannot have default value."
            case .incorrectNumberOfArguments(let functionName, let expected, let given):
                return "Expected \(expected) arguments in call to '\(functionName)', but got \(given)."
            case .incorrectTypeInFunctionCall(let functionName, let expected, let given, let position):
                return "Argument type at position \(position) in call to '\(functionName)' should be '\(expected)', not '\(given)'."
            case .dereferenceNonPointerType(let type):
                return "Cannot dereference non-pointer type '\(type)'."
            case .cannotFindAddressOfNonReference:
                return "Cannot use the '&' operator on non-reference expression."
            case .invalidSugaredAssignment(let `operator`):
                return "The operator '\(`operator`)' is not allowed in sugared assignments."
            case .incorrectReturnType(let expected, let given):
                return "Type '\(given)' cannot be converted to expected return type '\(expected)'."
            case .doesNotReturnOnAllPaths(let function):
                return "Function '\(function)' does not return a value on all paths."
            case .structIsRecursive(let structName):
                return "The struct '\(structName)' is recursive."
            case .unassignableLHS(let lhs):
                return "The expression \(lhs.readableDescription) is unassignable because it is not a local variable, pointer dereference or member access."
            case .hasNoValidMain:
                return "The exectuable must contain a valid int main() function."
            case .invalidMember(let invalid):
                return "Members must be referred to by name. The expression '\(invalid.readableDescription)' is not a valid member."
            case .grammaticalIssue(let description):
                return description
            case .illegalIntegerLiteral(let literal):
                return "Illegal integer literal \(literal)."
            }
        }()
        
    }
    
}


extension ParseError: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .unexpected(let nonTerminal, let found, let expected):
            return "Expected \(expected) in \(nonTerminal) but found '\(found)'."
        case .abruptEnd(let nonTerminal, let expected):
            return "Expected \(expected) in \(nonTerminal) but found end of file."
        }
        
    }
    
}
