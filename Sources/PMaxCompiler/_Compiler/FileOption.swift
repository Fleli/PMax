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
    case threeAddressCode
    case assemblyCode
    
    case errors
    case profile
    
}
