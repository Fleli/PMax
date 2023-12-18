import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

// TODO: "Update the Docs now that the folder structure has been reorganized.

final class Compiler {
    
    static var allowMeta = false
    static var allowPrinting = false
    
    var preprocessor: Preprocessor!
    
    var fileOptions: [FileOption] = []
    var profiler: CompilerProfiler!
    
    var encounteredErrors: [PMaxError] = []
    
    let libraryPaths: [String]
    
    let emitOffsets: Bool
    
    /// Initialize a `Compiler` instance with certain `libraryPaths`. These are the paths, in order, that the preprocessor searches in when attempting to import libraries. Using as "exact" paths as possible is recommended, since the preprocessor will literally expand the entire tree in its attempt to find the file that is referred to.
    public init(_ emitOffsets: Bool, _ libraryPaths: [String]) {
        self.emitOffsets = emitOffsets
        self.libraryPaths = libraryPaths
    }
    
    
    /// Add a file option to the compiler. For non-`nil` `path`s, content specified by the `debugOption` will be written to a file. If `path` is `nil`, the same content will instead be printed to the terminal.
    public func addFileOption(_ path: String?, _ debugOption: DebugOption) {
        let fileOption = FileOption(path, debugOption)
        fileOptions.append(fileOption)
    }
    
    
    public func printErrors() {
        if !encounteredErrors.readableFormat.isEmpty {
            Swift.print(encounteredErrors.readableFormat)
        }
    }
    
    
    public func compile(_ sourceCode: [String], _ asLibrary: Bool) throws {
        
        self.encounteredErrors.removeAll()
        self.profiler = CompilerProfiler()
        self.preprocessor = Preprocessor(self)
        
        do {
            
            try lex(sourceCode, asLibrary)
            
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
