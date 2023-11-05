import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

public final class Compiler {
    
    
    public static var allowMeta = true
    public static var allowPrinting = false
    
    
    var fileOptions: [FileOption]
    var profiler: CompilerProfiler!
    
    var encounteredErrors: [PMaxError] = []
    
    
    public init(_ fileOptions: FileOption ...) {
        self.fileOptions = fileOptions
    }
    
    
    public func compile(_ sourceCode: String) throws {
        
        self.encounteredErrors.removeAll()
        self.profiler = CompilerProfiler()
        
        do {
            
            try lex(sourceCode)
            
            let errorInformation = (encounteredErrors.readableFormat.count > 0) ? (encounteredErrors.readableFormat) : "\nSuccess!\n"
            write(.errors, errorInformation)
            
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
