enum PMaxError {
    
    case typeDoesNotExist(typeName: String)
    case circularStructDefinition(typeName: String)
    case invalidRedeclarationOfStruct(typeName: String)
    
}
