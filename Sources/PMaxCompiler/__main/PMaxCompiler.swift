import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

#warning("Update the Docs now that the folder structure has been reorganized.")

public final class Compiler {
    
    
    public static let version: String = "0.2.0"
    public static let date: String = "2023-11-18"
    
    public static var allowMeta = true
    public static var allowPrinting = false
    
    
    var preprocessor: Preprocessor!
    
    var fileOptions: [FileOption] = []
    var profiler: CompilerProfiler!
    
    var encounteredErrors: [PMaxError] = []
    
    let libraryPaths: [String]
    
    /// Initialize a `Compiler` instance with certain `libraryPaths`. These are the paths, in order, that the preprocessor searches in when attempting to import libraries. Using as "exact" paths as possible is recommended, since the preprocessor will literally expand the entire tree in its attempt to find the file that is referred to.
    public init(_ libraryPaths: [String]) {
        self.libraryPaths = libraryPaths
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
