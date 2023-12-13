import ArgumentParser
import Foundation

struct Build: ParsableCommand {
    
    
    @ArgumentParser.Option(help: "Specify the paths for the compiler to search for libraries in.")
    private var libPaths: [String] = []
    
    @ArgumentParser.Option(help: "Specify the name of the output assembly file.")
    private var outAsm: String?
    
    
    private var current = Foundation.FileManager().currentDirectoryPath
    
    
    func run() throws {
        
        Compiler.allowMeta = false
        Compiler.allowPrinting = false
        
        let compiler = Compiler(self.libPaths)
        
        // TODO: This should not necessarily happen (for libraries)
        let assemblyFilePath = current + "/_targets/" + (outAsm ?? "main.out")
        compiler.addFileOption(assemblyFilePath, .assemblyCode)
        
        do {
            
            let sourceCode = try assembleSourceCode()
            
            // Compiling as a library is not allowed yet, since this functionality is not finished.
            // TODO: Change this when the compiler is ready.
            let compileAsLibrary = false
            
            try compiler.compile(sourceCode, compileAsLibrary)
            compiler.printErrors()
            
        } catch {
            
            print(error)
            return
            
        }
        
    }
    
    
    private func assembleSourceCode() throws -> [String] {
        
        let sourceFolder = current + "/source"
        
        let allContent = deepSearch(sourceFolder, .collect(predicate: { $0.hasSuffix(".pmax") }))
        
        return allContent
        
    }
    
    
}

