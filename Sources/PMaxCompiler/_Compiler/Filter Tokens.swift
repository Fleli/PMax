extension Compiler {
    
    
    func filterTokens(_ rawTokens: [Token]) -> [Token] {
        
        var tokens: [Token] = []
        
        var index = 0
        
        // Extra lexing stage added due to limitations with SwiftLex.
        while index < rawTokens.count {
            
            if rawTokens[index].type == "comment" {
                
                while index < rawTokens.count, rawTokens[index].type != "newline" {
                    index += 1
                }
                
            } else if rawTokens[index].type != "space" && rawTokens[index].type != "newline" {
                
                tokens.append(rawTokens[index])
                
            }
            
            index += 1
            
        }
        
        return tokens
        
    }
    
    
}
