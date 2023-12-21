extension Preprocessor {
    
    func parseImport(_ library: String, _ hmaxFile: String) {
        
        let lexer = Lexer()
        let parser = SLRParser()
        
        do {
            
            let tokens = try lexer.lex(hmaxFile).filter { $0.type != "newline" && $0.type != "space" }
            
            guard let slrTree = try parser.parse(tokens) else {
                // TODO: Submit an error.
                print("Syntactical error.\n")
                return
            }
            
            let statements = slrTree.convertToTopLevelStatements()
            
            for statement in statements {
                
                switch statement {
                case .struct(let `struct`):
                    self.newStruct(library, `struct`)
                case .function(let function):
                    verifyFunction(library, function)
                case .import(_):
                    print("(Ignored) Transitive import")
                    // TODO: Get back to the issue of transitive imports. It requires care to be done right.
                    break
                }
                
            }
            
        } catch LexError.invalidCharacter(let char, let tokens) {
            
            print("Error. \(char).\n")
            
            tokens.forEach {
                print($0)
            }
            
        } catch {
            
            print("Error \(error)")
            
        }
        
    }
    
    private func verifyFunction(_ library: String, _ function: Function) {
        
        guard function.body.count == 2 else {
            // TODO: Submit error (ill-formed hmax-file)
            print("Expected two statements in body but found \(function.body.count): \(function.body)")
            return
        }
        
        guard let entryPoint = findEntryPoint(function.body[0]) else {
            // TODO: Submit an error.
            print("No entry point: \(function.body[0]) is ill-formed.")
            return
        }
        
        guard var assemblyCode = findAssemblyCode(function.body[1]) else {
            print("No code: \(function.body[1]) is ill-formed.")
            return
        }
        
        // Remove enclosing ""
        assemblyCode.removeFirst()
        assemblyCode.removeLast()
        
        self.newFunction(library, function, entryPoint, assemblyCode)
        
    }
    
    private func findEntryPoint(_ statement: FunctionBodyStatement) -> String? {
        
        guard case .declaration(let declaration) = statement, declaration.type == .basic("Label"), declaration.value == nil else {
            return nil
        }
        
        return declaration.name
        
    }
    
    private func findAssemblyCode(_ statement: FunctionBodyStatement) -> String? {
        
        guard case .assignment(let assignment) = statement, assignment.operator == nil, case .identifier("asm") = assignment.lhs else {
            return nil
        }
        
        guard case .string(let str) = assignment.rhs else {
            return nil
        }
        
        return str
        
    }
    
}
