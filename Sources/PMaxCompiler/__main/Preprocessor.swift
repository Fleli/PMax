import Foundation

class Preprocessor {
    
    
    typealias Structs = [String : PILStruct]
    typealias Functions = [String : PILFunction]
    
    typealias Closure = () -> ()
    
    
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
        
        parseImport(fileName, content)
        
    }
    
    
    /// Notify the preprocessor that a new `struct` was found in a given library.
    func newStruct(_ library: String, _ `struct`: Struct) {
        print("[External] Added struct \(`struct`.name) to the type pool.")
        lowerer.newStruct(`struct`)
    }
    
    
    /// Notify the preprocessor that a new function was encountered.The `function` parameter is used to verify that calls to it match the name, argument count, and types. `entry` and `body` are used in assembly lowering to create the actual link (upon calls) between the library and the caller.
    func newFunction(_ library: String, _ function: Function, _ entry: String, _ body: String) {
        print("[External] Added function \(function.name) to the function pool.")
        let function = PILFunction(function, body, entry, lowerer)
        lowerer.newFunction(function)
    }
    
    
}
