public struct FileOption {
    
    let path: String
    let result: CompilerIntermediateResult
    
    init(_ path: String, _ result: CompilerIntermediateResult) {
        self.path = path
        self.result = result
    }
    
}

public enum CompilerIntermediateResult {
    
    case tokens
    case parseTree
    case threeAddressCode
    case assemblyCode
    
}
