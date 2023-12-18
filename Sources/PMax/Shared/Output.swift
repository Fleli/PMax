import Foundation

extension Compiler {
    
    
    func write(_ result: DebugOption, _ content: String) {
        
        for option in self.fileOptions where option.result == result {
            
            if let path = option.path {
                writeToFile(path, content)
            } else {
                Swift.print(content)
            }
            
        }
        
    }
    
    
    func writeToFile(_ path: String, _ content: String) {
        
        let succeeded = FileManager.default.createFile(atPath: path, contents: content.data(using: .utf16))
        
        if Self.allowMeta {
            Swift.print("[Content: \(content)]")
            Swift.print("Writing to '\(path)' \(succeeded ? "succeeded" : "failed").")
        }
        
    }
    
    
}
