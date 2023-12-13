import ArgumentParser
import Foundation

struct Build: ParsableCommand {
    
    @ArgumentParser.Argument(help: "The file to compile.")
    private var file: String
    
    @ArgumentParser.Option(help: "Specify the paths for the compiler to search for libraries in.")
    private var libPaths: [String] = []
    
    @ArgumentParser.Option(help: "Specify where output files go.")
    private var targetLocation: String?
    
    func run() throws {
        
        let currentDirectory = Foundation.FileManager().currentDirectoryPath
        
        let assemblyFilePath = currentDirectory + "/" + (targetLocation ?? ".") + "/main.out"
        let assemblyFilePathOption = FileOption(assemblyFilePath, .assemblyCode)
        
        let file = currentDirectory + "/" + file
        
        Compiler.allowMeta = false
        Compiler.allowPrinting = false
        
        let compiler = Compiler(self.libPaths)
        
        // TODO: This should not necessarily happen (for libraries)
        compiler.addFileOption(assemblyFilePathOption)
        
        guard FileManager().fileExists(atPath: file) else {
            print("[Meta]  \tCannot compile \(self.file) because it does not exist.")
            print("[Meta]  \tPath: \(file)")
            return
        }
        
        do {
            
            let sourceCode = try String(contentsOfFile: file)
            
            // Compiling as a library is not allowed yet, since this function is not finished.
            // TODO: Change this when the compiler is ready.
            let compileAsLibrary = false
            
            try compiler.compile(sourceCode, compileAsLibrary)
            compiler.printErrors()
            
        } catch {
            
            print(error)
            return
            
        }
        
    }
    
}

