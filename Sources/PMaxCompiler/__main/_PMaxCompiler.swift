import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

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
        (Self.allowPrinting ? {Swift.print(string)} : {})()
    }
    
    
}
