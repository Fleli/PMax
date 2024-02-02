extension Compiler {
    
    
    // TODO: The lexer should contain file information, since tokens should be tied to a specific file (important for highlighting etc.)
    func lex(_ sourceCode: [String], _ asLibrary: Bool) throws {
        
        var tokens: [[Token]] = []
        
        for sourceCodeFile in sourceCode {
            
            let rawTokens = try Lexer().lex(sourceCodeFile)
            let fileTokens = filterTokens(rawTokens)
            
            tokens.append(fileTokens)
            
        }
        
        let tokensFileContent = tokens.map {$0.description}.reduce("", {$0 + $1 + "\n"})
        write(.tokens, tokensFileContent)
        profiler.register(.tokens)
        
        try parse(tokens, asLibrary)
        
    }
    
    
    func parse(_ tokens: [[Token]], _ asLibrary: Bool) throws {
        
        let tokens: [Token] = tokens.reduce([]) { $0 + $1 }
        
        let slrNodeTree = try SLRParser().parse(tokens)
        
        guard let slrNodeTree else {
            return
        }
        
        let slrNodeTreeFileContent = slrNodeTree.treeDescription(0)
        write(.parseTree, slrNodeTreeFileContent)
        
        let converted = slrNodeTree.convertToTopLevelStatements()
        profiler.register(.parseTree)
        
        lowerToPIL(converted, asLibrary)
        
    }
    
    
    func lowerToPIL(_ converted: TopLevelStatements, _ asLibrary: Bool) {
        
        let pilLowerer = PILLowerer(converted, preprocessor)
        pilLowerer.lower()
        
        encounteredErrors += pilLowerer.errors
        
        guard pilLowerer.noIssues else {
            return
        }
        
        write(.pmaxIntermediateLanguage, pilLowerer.readableDescription)
        profiler.register(.pmaxIntermediateLanguage)
        
        lowerToTAC(pilLowerer, asLibrary)
        
    }
    
    
    func lowerToTAC(_ pilLowerer: PILLowerer, _ asLibrary: Bool) {
        
        let tacLowerer = TACLowerer(pilLowerer, self.emitOffsets)
        tacLowerer.lower(asLibrary)
        
        encounteredErrors += tacLowerer.errors
        
        guard tacLowerer.noIssues else {
            return
        }
        
        write(.threeAddressCode, tacLowerer.description)
        profiler.register(.threeAddressCode)
        
        generateAssembly(tacLowerer, asLibrary)
        
    }
    
    
    func generateAssembly(_ tacLowerer: TACLowerer, _ asLibrary: Bool) {
        
        let asmLowerer = AssemblyLowerer(tacLowerer)
        
        let libCode = tacLowerer.libraryAssembly.reduce("") { $0 + $1 + "\n" }
        
        let code = asmLowerer.lower(asLibrary) + libCode
        
        let option: DebugOption = asLibrary ? .libraryCode : .assemblyCode
        write(option, code)
        profiler.register(option)
        
    }
    
    
}
