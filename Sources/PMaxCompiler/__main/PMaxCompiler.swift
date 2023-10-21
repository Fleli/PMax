public class Compiler {
    
    public init() {
        
        print("init compiler")
        
    }
    
    public func compile(_ sourceCode: String) throws {
        
        print("Source code = \(sourceCode)")
        
        let tokens = try Lexer().lex(sourceCode)
        tokens.forEach { print($0) }
        
        let slrNodeTree = try SLRParser().parse(tokens)
        slrNodeTree?.printFullDescription(0)
        
        guard let converted = slrNodeTree?.convertToTopLevelStatements() else {
            return
        }
        
        for statement in converted {
            switch statement {
            case .struct(let `struct`):
                print("struct \(`struct`.name)")
                `struct`.statements.forEach { print("   ", $0) }
            case .function(let function):
                print("\(function.returnType) \(function.name) \(function.parameters) {")
                function.body.forEach { print("   ", $0) }
                print("}")
            }
        }
        
        let pilLowerer = PILLowerer(converted)
        pilLowerer.lower()
        
        guard pilLowerer.errors.count == 0 else {
            print("Errors were found. Terminating compilation before TAC lowering.")
            return
        }
        
        let tacLowerer = TACLowerer(pilLowerer)
        tacLowerer.lower()
        
        guard tacLowerer.errors.count == 0 else {
            print("Errors were found. Terminating compilation before ASM lowering.")
            return
        }
        
        let labels = tacLowerer.labels
        let asmLowerer = AssemblyLowerer(labels)
        asmLowerer.lower()
        
    }
    
}
