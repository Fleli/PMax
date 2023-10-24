import Foundation

public final class Compiler {
    
    
    public static var allowMeta = true
    public static var allowPrinting = true
    
    
    var fileOptions: [FileOption]
    
    
    var profiler: CompilerProfiler!
    
    
    public init(_ fileOptions: FileOption ...) {
        self.fileOptions = fileOptions
    }
    
    
    public func compile(_ sourceCode: String) throws {
        
        write(.errors, "\nSuccess!\n")
        
        self.profiler = CompilerProfiler()
        
        do {
            
            try lex(sourceCode)
            
        } catch {
            
            Self.print("Compilation failed. Error: \(error)")
            write(.errors, error.localizedDescription)
            
        }
        
        let profileDescription = profiler.description
        write(.profile, profileDescription)
        
    }
    
    
    static func print(_ string: String) {
        if Self.allowPrinting {
            Swift.print(string)
        }
    }
    
    
}
