import Foundation

struct MainDefaults {
    
    static let sourceSubPath = "sources"
    
    static func mainPMaxDefault(_ name: String?, _ asLibrary: Bool) -> String {
        
        let date = dateString()
        let nameLine = nameString(name)
        
        return (
            """
            // main.pmax
            \(nameLine)\(date)
            \(body(asLibrary))
            """
        )
        
    }
    
    private static func dateString() -> String {
        
        if #available(macOS 12.0, *) {
            return "// Created " + Foundation.Date.now.formatted(date: .numeric, time: .omitted).description + "\n"
        } else {
            return ""
        }
        
    }
    
    private static func nameString(_ name: String?) -> String {
        
        if let name {
            return "// Copyright (c) \(name)\n"
        } else {
            return ""
        }
        
    }
    
    private static func body(_ asLibrary: Bool) -> String {
        
        if !asLibrary {
            
            return """
            func main() -> \(Builtin.native) {
            \t
            \treturn 0;
            \t
            }
            
            """
            
        }
        
        return ""
        
    }
    
}
