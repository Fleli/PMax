import Foundation

class Preprocessor {
    
    typealias Closure = () -> ()
    
    let libraryPaths: [String]
    
    let fileManager = Foundation.FileManager()
    
    private var importedLibraries: Set<String> = []
    
    weak var compiler: Compiler!
    
    
    init(_ compiler: Compiler) {
        
        self.compiler = compiler
        self.libraryPaths = compiler.libraryPaths
        
        // For testing purposes:
        importLibrary("Stdlib")
        
    }
    
    
    func importLibrary(_ fileName: String) {
        
        let fileName = fileName + ".hmax"
        
        if importedLibraries.contains(fileName) {
            // TODO: Get back to this.
            // Probably doesn't need to submit error: If a library is already imported, just don't reimport it.
            return
        }
        
        print("Search through directories \(libraryPaths)")
        
        var pathIndex = 0
        var content: String? = nil
        
        while (pathIndex < libraryPaths.count) && (content == nil) {
            
            let path = libraryPaths[pathIndex]
            
            content = searchThroughDirectory(for: fileName, in: path)
            
            pathIndex += 1
            
        }
        
        guard let content else {
            // TODO: Submit an issue: The library (file) wasn't found.
            print("No file '\(fileName)' in the current directory or any of its children.")
            return
        }
        
        print("Result of search: {\(content)}")
        
    }
    
    
    /// Notify the preprocessor that a new `struct` was found in a given library.
    func newStruct(_ library: String, _ `struct`: Struct) {
        
        
        
    }
    
    
    /// Notify the preprocessor that a new function was encountered.The `function` parameter is used to verify that calls to it match the name, argument count, and types. `entry` and `body` are used in assembly lowering to create the actual link (upon calls) between the library and the caller.
    func newFunction(_ library: String, _ function: Function, _ entry: String, _ body: String) {
        
        print("New function: \(function.name) entry @ \(entry) with body {\(body)}")
        
    }
    
    
}
