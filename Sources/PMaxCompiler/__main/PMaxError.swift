enum PMaxError {
    
    case typeDoesNotExist(typeName: String)
    case circularStructDefinition(typeName: String)
    case invalidRedeclarationOfStruct(typeName: String)
    case invalidRedeclarationOfFunction(functionName: String)  // TODO: [Not critical] Consider adding more information to this for better error handling.
    
}
