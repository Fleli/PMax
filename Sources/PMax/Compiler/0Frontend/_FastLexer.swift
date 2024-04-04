
extension String {
    
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    subscript(inclusiveStart: Int, exclusiveEnd: Int) -> String {
        return String(self[index(startIndex, offsetBy: inclusiveStart) ..< index(startIndex, offsetBy: exclusiveEnd)])
    }
    
    static let keywords = ["while", "if", "else", "struct", "return", "call", "import", "sizeof", "macro", "func", "var"]
    
}

// Regions aren't really used in the compiler even though the Token type supports them.
// Thus, the FastLexer ignores them for now.
extension Region {
    static let null = Region(0, 0, 0, 0)
}

class FastLexer {
    
    var index: Int = 0
    var input: String = ""
    
    var tokens: [Token] = []
    
    func lex(_ input: String) throws -> [Token] {
        
        self.prepare(input)
        
        while (index < input.count) {
            try findNextToken()
        }
        
        return self.tokens
        
    }
    
    private func prepare(_ input: String) {
        
        self.index = 0
        self.input = input
        self.tokens = []
        
    }
    
    private func findNextToken() throws {
        
        let char = input[index]
        
        if char.isLetter || char == "_" {
            lexIdentifier()
        } else if let arrow = matchExact("->", "->") {
            tokens.append(arrow)
        } else if let minus = matchExact("-", "-") {
            tokens.append(minus)
        } else if char.isNumber || char == "-" {
            lexNumber()
        } else if char == "\"" {
            try lexString()
        } else if char == "'" {
            try lexChar()
        } else if let _ = matchExact("--", "//") {
            lexComment()
        }
        
        else {
            
        switchLabel: switch input[index] {
            case " ", " ", "\n", "\t":
                index += 1
            default:
                
                for typ in ["<<", ">>", "<=", ">=", "@", "==", "!=", "[", "]", "(", ")", "{", "}", "+", "*", "/", "%", "&", "|", "!", "?", ".", ",", ":", ";", "_", "=", "<", ">", "~"] {
                    if let token = matchExact(typ, typ) {
                        tokens.append(token)
                        break switchLabel
                    }
                }
                
                throw LexError.invalidCharacter(char, self.tokens)
                
            }
            
        }
        
    }
    
    private func matchExact(_ type: String, _ content: String) -> Token? {
        
        guard index <= input.count - content.count else {
            return nil
        }
        
        guard input[index, index + content.count] == content else {
            return nil
        }
        
        index += content.count
        
        return Token(type, content, .null)
        
    }
    
    private func matchWhileSatisfied( _ function: (Character) -> (Bool) ) -> String {
        
        let start = index
        
        while (index < input.count)  &&  function(input[index]) {
            index += 1
        }
        
        return input[start, index]
        
    }
    
    private func lexIdentifier() {
        
        let content = matchWhileSatisfied {
            $0.isLetter || $0.isNumber || $0 == "_"
        }
        
        let type = (String.keywords.contains(content)) ? content : "identifier"
        
        tokens.append( Token(type, content, .null) )
        
    }
    
    private func lexNumber() {
        
        let isNegative = (input[index] == "-")
        index = isNegative ? index + 1 : index
        
        let content = (isNegative ? "-" : "") + matchWhileSatisfied {
            $0.isNumber
        }
        
        tokens.append( Token("integer", content, .null) )
        
    }
    
    private func lexString() throws {
        
        index += 1
        
        // TODO: Allow escape sequences within the string
        let content = matchWhileSatisfied {
            $0 != "\""
        }
        
        guard input[index] == "\"" else {
            throw LexError.invalidCharacter("\"", tokens)
        }
        
        index += 1
        
        tokens.append( Token("string", "\"" + content + "\"", .null) )
        
    }
    
    private func lexChar() throws {
        
        index += 1
        
        // TODO: Allow escape sequences within the string
        let content = matchWhileSatisfied {
            $0 != "'"
        }
        
        guard input[index] == "'" else {
            throw LexError.invalidCharacter("'", tokens)
        }
        
        index += 1
        
        tokens.append( Token("char", "'" + content + "'", .null) )
        
    }
    
    private func lexComment() {
        
        let _ = matchWhileSatisfied {
            $0 != "\n"
        }
        
    }
    
}
