extension Preprocessor {
    
    func parseImport(_ library: String, _ hmaxFile: String) {
        
        let lexer = Lexer()
        let parser = SLRParser()
        
        do {
            
            let tokens = try lexer.lex(hmaxFile).filter { $0.type != "newline" && $0.type != "space" }
            
            guard let slrTree = try parser.parse(tokens) else {
                // TODO: Submit an error.
                return
            }
            
            let statements = slrTree.convertToTopLevelStatements()
            
            for statement in statements {
                
                switch statement {
                case .struct(let `struct`):
                    self.newStruct(library, `struct`)
                case .function(let function):
                    verifyFunction(library, function)
                }
                
            }
            
        } catch {
            
            print("Error \(error)")
            
        }
        
    }
    
    private func verifyFunction(_ library: String, _ function: Function) {
        
        guard function.body.count == 2 else {
            // TODO: Submit error (ill-formed hmax-file)
            return
        }
        
        guard let entryPoint = findEntryPoint(function.body[0]) else {
            // TODO: Submit an error.
            return
        }
        
    }
    
    private func findEntryPoint(_ statement: FunctionBodyStatement) -> String? {
        
        guard case .declaration(let declaration) = statement, declaration.type == .basic("Label"), declaration.value == nil else {
            return nil
        }
        
        return declaration.name
        
    }
    
}
