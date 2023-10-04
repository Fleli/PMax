enum PMaxError {
    
    case typeDoesNotExist(typeName: String)
    case circularStructDefinition(typeName: String)
    case invalidRedeclarationOfStruct(typeName: String)
    case invalidRedeclarationOfFunction(functionName: String)  // TODO: [Not critical] Consider adding more information to this for better error handling.
    case declarationAlreadyExists(name: String, existingType: String, attemptedType: String)
    case variableDoesNotExist(name: String)
    
}
