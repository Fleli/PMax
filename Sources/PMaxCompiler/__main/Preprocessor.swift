import Foundation

class Preprocessor {
    
    typealias Closure = () -> ()
    
    let fileManager = Foundation.FileManager()
    
    private var currentDirectory: String {
        fileManager.currentDirectoryPath
    }
    
    private var importedLibraries: Set<String> = []
    
    weak var compiler: Compiler!
    
    
    init(_ compiler: Compiler?) {
        self.compiler = compiler
        importLibrary("non")
    }
    
    
    func importLibrary(_ fileName: String) {
        
        let testFile = """
        
        struct Array {
            int size;
            int count;
            void** data;
        }
        
        void array_insert(Array* array, void* data) {
            return;
        }
        
        void array_removeLast(Array* array) {
            Label entryp;
            assign asm = "l
        kdnf
        dmsf
        
        dmnf\tmfgll";
        }
        
        """
        
        self.parseImport(fileName, testFile)
        
        /*
        let fileName = fileName + ".hmax"
        
        if importedLibraries.contains(fileName) {
            // TODO: Get back to this.
            // Probably doesn't need to submit error: If a library is already imported, just don't reimport it.
            return
        }
        
        print("Working directory: \(currentDirectory)")
        
        guard let content = searchThroughDirectory(for: fileName, in: currentDirectory) else {
            // TODO: Submit an issue: The library (file) wasn't found.
            print("No file '\(fileName)' in the current directory or any of its children.")
            return
        }
        
        print("Result of search: {\(content)}")
        */
    }
    
    
    /// Notify the preprocessor that a new `struct` was found in a given library.
    func newStruct(_ library: String, _ `struct`: Struct) {
        
        
        
    }
    
    
    /// Notify the preprocessor that a new function was encountered.The `function` parameter is used to verify that calls to it match the name, argument count, and types. `entry` and `body` are used in assembly lowering to create the actual link (upon calls) between the library and the caller.
    func newFunction(_ library: String, _ function: Function, _ entry: String, _ body: String) {
        
        print("New function: \(function.name) entry @ \(entry) with body {\(body)}")
        
    }
    
    
}
