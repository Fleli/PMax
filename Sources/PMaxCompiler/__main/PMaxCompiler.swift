import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

#warning("Update the Docs now that the folder structure is reorganized.")
#warning("Reorganized the folder structure will create a merge conflict in Git.")
// Force push this branch to main, then reimplement the small changes made in the two commits this branch hadn't pulled.

public final class Compiler {
    
    
    public static let version: String = "0.1.1"
    public static let date: String = "2023-11-10"
    
    public static var allowMeta = true
    public static var allowPrinting = false
    
    
    var preprocessor: Preprocessor!
    
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
        self.preprocessor = Preprocessor(self)
        
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
