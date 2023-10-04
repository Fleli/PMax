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
        
        print(converted.description)
        
        print("Will now start lowering\n")
        
        let aspartame = Aspartame()
        aspartame.convert(converted)
        
        let decarbonator = Decarbonator(aspartame)
        decarbonator.decarbonate()
        
    }
    
}
