
extension Compiler {
    
    func runCompilationPasses(_ sourceCode: [String], _ asLibrary: Bool, _ emitOffsets: Bool) throws {
        
        
        // LEXICAL ANALYSIS
        
        print("lex")
        
        
        var fileSeparatedTokens: [[Token]] = []
        
        for sourceCodeFile in sourceCode {
            
            let tokens = try FastLexer().lex(sourceCodeFile)
            
            print("File tokens:")
            for tok in tokens {
                print(tok)
            }
            
            fileSeparatedTokens.append(tokens)
            
        }
        
        let tokens = fileSeparatedTokens.reduce([]) {$0 + $1}
        
        let tokensFileContent = tokens.reduce("") { $0 + $1.description + "\n" }
        write(.tokens, tokensFileContent)
        
        profiler.register(.tokens)
        
        
        print("--")
        
        
        // PARSING
        
        
        print("parse")
        
        
        let slrNodeTree = try SLRParser().parse(tokens)
        
        guard let slrNodeTree else {
            return
        }
        
        let slrNodeTreeFileContent = slrNodeTree.treeDescription(0)
        write(.parseTree, slrNodeTreeFileContent)
        
        let converted = slrNodeTree.convertToTopLevelStatements()
        profiler.register(.parseTree)
        
        print("--")
        
        
        // PMAX INTERMEDIATE LANGUAGE
        
        
        print("pil")
        
        let pilLowerer = PILLowerer(converted, preprocessor, self)
        pilLowerer.lower()
        
        guard hasNoIssues() else {
            return
        }
        
        write(.pmaxIntermediateLanguage, pilLowerer.readableDescription)
        profiler.register(.pmaxIntermediateLanguage)
        
        print("--")
        
        // THREE-ADDRESS CODE
        
        
        print("tac")
        let tacLowerer = TACLowerer(pilLowerer, emitOffsets, self)
        tacLowerer.lower(asLibrary)
        
        guard hasNoIssues() else {
            return
        }
        
        write(.threeAddressCode, tacLowerer.description)
        profiler.register(.threeAddressCode)
        
        print("--")
        
        // ASSEMBLY CODE GENERATION
        
        
        print("asm")
        let asmLowerer = AssemblyLowerer(tacLowerer)
        
        let libCode = tacLowerer.libraryAssembly
        
        let code = asmLowerer.lower(asLibrary) + libCode
        
        let option: DebugOption = asLibrary ? .libraryCode : .assemblyCode
        write(option, code)
        profiler.register(option)
        
        print("--")
        
    }
    
}
