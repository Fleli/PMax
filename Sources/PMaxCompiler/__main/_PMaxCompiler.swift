import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

public final class Compiler {
    
    
    public static var allowMeta = true
    public static var allowPrinting = false
    
    public func printErrors() {
        Swift.print(encounteredErrors.readableFormat)
    }
    
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
            
        } catch let error as ParseError {
            
            encounteredErrors.append(PMaxIssue.grammaticalIssue(description: error.description))
            
        } catch {
            
            encounteredErrors.append(PMaxIssue.grammaticalIssue(description: "Unknown grammatical issue: \(error.localizedDescription)"))
            
        }
        
        write(.errors, encounteredErrors.readableFormat)
        
        let profileDescription = profiler.description
        write(.profile, profileDescription)
        
    }
    
    
    static func print(_ string: String) {
        (Self.allowPrinting ? {Swift.print(string)} : {})()
    }
    
    
}
