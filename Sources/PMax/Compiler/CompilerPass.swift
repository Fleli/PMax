
class CompilerPass {
    
    private let compiler: Compiler
    
    init(_ compiler: Compiler) {
        self.compiler = compiler
    }
    
    func autoVariableName(_ prefix: String) -> String {
        return compiler.autoVariableName(prefix)
    }
    
    func submitError(_ newError: PMaxError) {
        compiler.submitError(newError)
    }
    
}
