import Foundation

struct Shared {
    
    static let sourcePath = "source"
    
    static let makefileDefault = """
    
    all: setup
    \tpmax build --out-asm output.out
    
    setup:
    \t@echo "Test 'setup'."
    
    """
    
    static func mainPMaxDefault(name: String?) -> String {
        
        let date: String
        
        if #available(macOS 12.0, *) {
            date = "// Created " + Foundation.Date.now.formatted(date: .numeric, time: .omitted).description + "\n"
        } else {
            date = ""
        }
        
        var nameLine = ""
        
        if let name {
            nameLine = "// Copyright (c) \(name)\n"
        }
        
        return (
            """
            // main.pmax
            \(nameLine)\(date)
            int main() {
            \t
            \treturn 0;
            \t
            }
            
            """
        )
        
    }
    
}
