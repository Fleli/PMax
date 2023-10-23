public struct FileOption {
    
    let path: String
    let result: CompilerIntermediateResult
    
    public init(_ path: String, _ result: CompilerIntermediateResult) {
        self.path = path
        self.result = result
    }
    
}

public enum CompilerIntermediateResult {
    
    case tokens
    case parseTree
    case threeAddressCode
    case assemblyCode
    
    case errors
    
}
