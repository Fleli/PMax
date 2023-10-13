enum PMaxError: CustomStringConvertible {
    
    case cannotFindMemberOfNonStructType(member: String, type: PILType)
    case typeDoesNotExist(typeName: String)
    case fieldDoesNotExist(structName: String, field: String)
    case redeclarationOfField(structName: String, field: String)
    case assignmentTypeMismatch(variable: String, expected: PILType, actual: PILType)
    case redeclarationOfVariable(varName: String, existing: PILType, new: PILType)
    case variableIsNotDeclared(name: String)
    case unaryOperatorNotDefined(op: String, argType: PILType)
    case binaryOperatorNotDefined(op: String, arg1Type: PILType, arg2Type: PILType)
    
    var description: String {
        switch self {
        case .cannotFindMemberOfNonStructType(let member, let type):
            return "Cannot find member '\(member)' of non-struct type '\(type)'."
        case .typeDoesNotExist(let typeName):
            return "The type '\(typeName)' does not exist."
        case .fieldDoesNotExist(let structName, let field):
            return "The property '\(field)' does not exist on '\(structName)'."
        case .redeclarationOfField(let structName, let field):
            return "Redeclaration of field '\(field)' on struct '\(structName)'."
        case .assignmentTypeMismatch(let variable, let expected, let actual):
            return "Cannot assign value of type '\(actual)' to '\(variable)' of type '\(expected)'."
        case .redeclarationOfVariable(let varName, let existing, let new):
            return "The variable '\(existing) \(varName)' is already declared within this scope, so '\(new) \(varName)' cannot be declared."
        case .variableIsNotDeclared(let name):
            return "The variable '\(name)' is not declared in this or any of its enclosing scopes."
        case .unaryOperatorNotDefined(let op, let argType):
            return "The unary operator '\(op)' is not defined on operand of type '\(argType)'."
        case .binaryOperatorNotDefined(let op, let arg1Type, let arg2Type):
            return "The binary operator '\(op)' is not defined on operands of types '\(arg1Type)' and '\(arg2Type)'."
        }
    }
    
}
