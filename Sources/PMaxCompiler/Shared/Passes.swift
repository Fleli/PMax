extension Compiler {
    
    
    func lex(_ sourceCode: String) throws {
        
        let rawTokens = try Lexer().lex(sourceCode)
        let tokens = filterTokens(rawTokens)
        
        let tokensFileContent = tokens.map {$0.description}.reduce("", {$0 + $1 + "\n"})
        write(.tokens, tokensFileContent)
        profiler.register(.tokens)
        
        try parse(tokens)
        
    }
    
    
    func parse(_ tokens: [Token]) throws {
        
        let slrNodeTree = try SLRParser().parse(tokens)
        
        guard let slrNodeTree else {
            return
        }
        
        let slrNodeTreeFileContent = slrNodeTree.treeDescription(0)
        write(.parseTree, slrNodeTreeFileContent)
        
        let converted = slrNodeTree.convertToTopLevelStatements()
        profiler.register(.parseTree)
        
        lowerToPIL(converted)
        
    }
    
    
    func lowerToPIL(_ converted: TopLevelStatements) {
        
        let pilLowerer = PILLowerer(converted, preprocessor)
        pilLowerer.lower()
        
        encounteredErrors += pilLowerer.errors
        
        guard pilLowerer.noIssues else {
            return
        }
        
        write(.pmaxIntermediateLanguage, pilLowerer.readableDescription)
        profiler.register(.pmaxIntermediateLanguage)
        
        lowerToTAC(pilLowerer)
        
    }
    
    
    func lowerToTAC(_ pilLowerer: PILLowerer) {
        
        let tacLowerer = TACLowerer(pilLowerer)
        tacLowerer.lower()
        
        encounteredErrors += tacLowerer.errors
        
        guard tacLowerer.noIssues else {
            return
        }
        
        write(.threeAddressCode, tacLowerer.description)
        profiler.register(.threeAddressCode)
        
        generateAssembly(tacLowerer)
        
    }
    
    
    func generateAssembly(_ tacLowerer: TACLowerer) {
        
        let labels = tacLowerer.labels
        let asmLowerer = AssemblyLowerer(labels)
        
        let code = asmLowerer.lower()
        write(.assemblyCode, code)
        profiler.register(.assemblyCode)
        
    }
    
    
}
