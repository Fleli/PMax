enum PILFunctionBody {
    
    case pmax(underlyingFunction: Function, lowered: [PILStatement])
    case external(assembly: String, entry: String)
    
}
