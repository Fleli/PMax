import Foundation

class Preprocessor {
    
    weak var compiler: Compiler!
    
    var importedLibraries: Set<String> = []
    
    let libraryPaths: [String]
    
    let fileManager = Foundation.FileManager()
    
    var lowerer: PILLowerer! = nil
    
    
    init(_ compiler: Compiler) {
        
        self.compiler = compiler
        self.libraryPaths = compiler.libraryPaths
        
    }
    
    
    func importLibrary(_ fileName: String, _ lowerer: PILLowerer) {
        
        self.lowerer = lowerer
        
        let fileName = fileName + ".hmax"
        
        if importedLibraries.contains(fileName) {
            // TODO: Get back to this.
            // Probably doesn't need to submit error: If a library is already imported, just don't reimport it.
            return
        }
        
        var pathIndex = 0
        var content: [String] = []
        
        while (pathIndex < libraryPaths.count) && (content.isEmpty) {
            
            let path = libraryPaths[pathIndex]
            
            content = deepSearch(path, .one(match: fileName))
            
            pathIndex += 1
            
        }
        
        guard content.count > 0 else {
            // TODO: Submit an issue: The library (file) wasn't found.
            print("Did not find '\(fileName)' in any of the listed 'import' directories: {")
            for dir in libraryPaths {
                print("\t\(dir)")
            }
            print("}")
            return
        }
        
        parseImport(fileName, content[0])
        
    }
    
    
    /// Notify the preprocessor that a new `struct` was found in a given library.
    func newStruct(_ library: String, _ `struct`: Struct) {
        lowerer.newStruct(`struct`)
    }
    
    
    /// Notify the preprocessor that a new function was encountered.The `function` parameter is used to verify that calls to it match the name, argument count, and types. `entry` and `body` are used in assembly lowering to create the actual link (upon calls) between the library and the caller.
    func newFunction(_ library: String, _ function: Function, _ entry: String, _ body: String) {
        let function = PILFunction(function, body, entry, lowerer)
        lowerer.newFunction(function)
    }
    
    
}
