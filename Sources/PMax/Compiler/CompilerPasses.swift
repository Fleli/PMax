
extension Compiler {
    
    func runCompilationPasses(_ sourceCode: [String], _ asLibrary: Bool, _ emitOffsets: Bool) throws {
        
        
        print("Start lex")
        
        
        // LEXICAL ANALYSIS
        
        
        var fileSeparatedTokens: [[Token]] = []
        
        for sourceCodeFile in sourceCode {
            
            let rawTokens = try Lexer().lex(sourceCodeFile)
            let fileTokens = filterTokens(rawTokens)
            
            fileSeparatedTokens.append(fileTokens)
            
        }
        
        let tokens = fileSeparatedTokens.reduce([]) {$0 + $1}
        
        let tokensFileContent = tokens.reduce("") { $0 + $1.description + "\n" }
        write(.tokens, tokensFileContent)
        
        profiler.register(.tokens)
        
        
        print("Start parse")
        
        
        // PARSING
        
        
        let slrNodeTree = try SLRParser().parse(tokens)
        
        guard let slrNodeTree else {
            return
        }
        
        let slrNodeTreeFileContent = slrNodeTree.treeDescription(0)
        write(.parseTree, slrNodeTreeFileContent)
        
        let converted = slrNodeTree.convertToTopLevelStatements()
        profiler.register(.parseTree)
        
        
        // PMAX INTERMEDIATE LANGUAGE
        
        
        let pilLowerer = PILLowerer(converted, preprocessor, self)
        pilLowerer.lower()
        
        guard hasNoIssues() else {
            return
        }
        
        write(.pmaxIntermediateLanguage, pilLowerer.readableDescription)
        profiler.register(.pmaxIntermediateLanguage)
        
        
        // THREE-ADDRESS CODE
        
        
        let tacLowerer = TACLowerer(pilLowerer, emitOffsets, self)
        tacLowerer.lower(asLibrary)
        
        guard hasNoIssues() else {
            return
        }
        
        write(.threeAddressCode, tacLowerer.description)
        profiler.register(.threeAddressCode)
        
        
        // ASSEMBLY CODE GENERATION
        
        
        let asmLowerer = AssemblyLowerer(tacLowerer)
        
        let libCode = tacLowerer.libraryAssembly
        
        let code = asmLowerer.lower(asLibrary) + libCode
        
        let option: DebugOption = asLibrary ? .libraryCode : .assemblyCode
        write(option, code)
        profiler.register(option)
        
    }
    
}
