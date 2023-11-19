public struct FileOption {
    
    let path: String
    let result: DebugOption
    
    public init(_ path: String, _ result: DebugOption) {
        self.path = path
        self.result = result
    }
    
}

public enum DebugOption {
    
    case tokens
    case parseTree
    case pmaxIntermediateLanguage
    case threeAddressCode
    
    case libraryCode
    case assemblyCode
    
    case errors
    case profile
    
}
