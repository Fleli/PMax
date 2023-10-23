import Foundation

extension Compiler {
    
    
    func write(_ result: CompilerIntermediateResult, _ content: String) {
        
        for option in self.fileOptions where option.result == result {
            writeToFile(option.path, content)
        }
        
    }
    
    
    func writeToFile(_ path: String, _ content: String) {
        
        let succeeded = FileManager.default.createFile(atPath: path, contents: content.data(using: .utf16))
        
        if Self.allowMeta {
            Swift.print("Writing to '\(path)' \(succeeded ? "succeeded" : "failed").")
        }
        
    }
    
    
}
