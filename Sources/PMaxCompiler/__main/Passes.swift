extension Compiler {
    
    
    func lex(_ sourceCode: String) throws {
        
        let tokens = try Lexer().lex(sourceCode)
        
        let tokensFileContent = tokens.map {$0.description}.reduce("", {$0 + $1 + "\n"})
        write(.tokens, tokensFileContent)
        
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
        lowerToPIL(converted)
        
    }
    
    
    func lowerToPIL(_ converted: TopLevelStatements) {
        
        let pilLowerer = PILLowerer(converted)
        pilLowerer.lower()
        
        guard pilLowerer.errors.count == 0 else {
            write(.errors, pilLowerer.errors.readableFormat)
            return
        }
        
        lowerToTAC(pilLowerer)
        
    }
    
    
    func lowerToTAC(_ pilLowerer: PILLowerer) {
        
        let tacLowerer = TACLowerer(pilLowerer)
        tacLowerer.lower()
        
        guard tacLowerer.errors.count == 0 else {
            write(.errors, tacLowerer.errors.readableFormat)
            return
        }
        
        write(.threeAddressCode, tacLowerer.description)
        
        generateAssembly(tacLowerer)
        
    }
    
    
    func generateAssembly(_ tacLowerer: TACLowerer) {
        
        let labels = tacLowerer.labels
        let asmLowerer = AssemblyLowerer(labels)
        
        let code = asmLowerer.lower()
        write(.assemblyCode, code)
        
    }
    
    
}
