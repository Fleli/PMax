import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

public final class Compiler {
    
    
    public static let version: String = "0.1.1"
    public static let date: String = "2023-11-10"
    
    public static var allowMeta = true
    public static var allowPrinting = false
    
    
    var fileOptions: [FileOption] = []
    var profiler: CompilerProfiler!
    
    var encounteredErrors: [PMaxError] = []
    
    
    public init() {
        
    }
    
    
    public func addFileOption(_ option: FileOption) {
        fileOptions.append(option)
    }
    
    
    public func printErrors() {
        Swift.print(encounteredErrors.readableFormat)
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
