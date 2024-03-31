import Foundation

// TODO: Consider enforcing that the argument label matches the parameter label. This increases consistency, but using different labels _may_ increase clarity in some cases

// TODO: "Update the Docs now that the folder structure has been reorganized.

final class Compiler {
    
    var allowMeta = false
    var allowPrinting = false
    
    private var autoIDCounter = 0
    private var errors: [PMaxError] = []
    
    var preprocessor: Preprocessor!
    
    var fileOptions: [FileOption] = []
    var profiler: CompilerProfiler!
    
    let libraryPaths: [String]
    
    
    func hasNoIssues() -> Bool {
        errors.filter { !$0.allowed }.count == 0
    }
    
    
    func autoVariableName(_ prefix: String) -> String {
        self.autoIDCounter += 1
        return "\(prefix)\(autoIDCounter)"
    }
    
    
    func submitError(_ newError: PMaxError) {
        errors.append(newError)
    }
    
    /// Initialize a `Compiler` instance with certain `libraryPaths`. These are the paths, in order, that the preprocessor searches in when attempting to import libraries. Using as "exact" paths as possible is recommended, since the preprocessor will literally expand the entire tree in its attempt to find the file that is referred to.
    public init(_ libraryPaths: [String]) {
        self.libraryPaths = libraryPaths
    }
    
    
    /// Add a file option to the compiler. For non-`nil` `path`s, content specified by the `debugOption` will be written to a file. If `path` is `nil`, the same content will instead be printed to the terminal.
    public func addFileOption(_ path: String?, _ debugOption: DebugOption) {
        let fileOption = FileOption(path, debugOption)
        fileOptions.append(fileOption)
    }
    
    public func compile(_ sourceCode: [String], _ asLibrary: Bool, _ emitOffsets: Bool) throws {
        
        self.profiler = CompilerProfiler()
        
        self.preprocessor = Preprocessor(self)
        
        do {
            
            try runCompilationPasses(sourceCode, asLibrary, emitOffsets)
            
        } catch {
            
            submitError(PMaxIssue.grammaticalIssue(description: "Grammatical issue: \(error.localizedDescription)"))
            
        }
        
        write(.errors, errors.readableFormat)
        
        let profileDescription = profiler.description
        
        write(.profile, profileDescription)
        
        guard hasNoIssues() else {
            
            print(errors.count)
            
            for error in errors {
                print(error.description)
            }
            
            exit(2)
            
        }
        
    }
    
}
