enum PMaxError {
    
    case typeDoesNotExist(typeName: String)
    case circularStructDefinition(typeName: String)
    case invalidRedeclarationOfStruct(typeName: String)
    case invalidRedeclarationOfFunction(functionName: String)  // TODO: [Not critical] Consider adding more information to this for better error handling.
    case declarationAlreadyExists(name: String, existingType: String, attemptedType: String)
    case variableDoesNotExist(name: String)
    case intLiteralNotWithinBounds(literal: String)
    case doesNotHaveMember(variable: String, type: String, member: String)
    case attemptedNonStructMember(variable: String, type: String)
    case assignmentTypeMismatch(lhs: String, lhsType: String, rhsType: String)
    
    
    var description: String {
        switch self {
        case .typeDoesNotExist(let typeName):
            return "The type '\(typeName)' does not exist."
        case .circularStructDefinition(let typeName):
            return "The struct '\(typeName)' contains a circular reference. Did you mean to use a pointer?"
        case .invalidRedeclarationOfStruct(let typeName):
            return "Redeclaration of the struct '\(typeName)'."
        case .invalidRedeclarationOfFunction(let functionName):
            return "Redeclaration of the function '\(functionName)'."
        case .declarationAlreadyExists(let name, let existingType, let attemptedType):
            return "A variable of type '\(existingType)' named '\(name)' already exists. New declaration of type '\(attemptedType)' is not allowed."
        case .variableDoesNotExist(let name):
            return "The variable '\(name)' does not exist within this scope."
        case .intLiteralNotWithinBounds(let literal):
            return "The integer literal '\(literal)' is not within the allowed bounds."
        case .doesNotHaveMember(let variable, let type, let member):
            return "The variable '\(variable)' of type '\(type)' has no member '\(member)'."
        case .attemptedNonStructMember(let variable, let type):
            return "Cannot access members of '\(variable)' of non-struct type '\(type)'."
        case .assignmentTypeMismatch(let lhs, let lhsType, let rhsType):
            return "Cannot assign value of type '\(rhsType)' to '\(lhs)' of type '\(lhsType)'."
        }
    }
    
    
}
