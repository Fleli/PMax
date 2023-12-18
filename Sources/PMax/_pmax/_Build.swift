
import ArgumentParser
import Foundation


struct Build: ParsableCommand {
    
    
    // MARK: Private variables
    
    
    private var current = Foundation.FileManager().currentDirectoryPath
    
    
    // MARK: Command-line arguments, options and flags
    
    
    @ArgumentParser.Option(help: "Specify the paths for the compiler to search for libraries in.")
    private var libPaths: [String] = []
    
    @ArgumentParser.Option(help: "Specify the name of the output file.")
    private var targetName: String?
    
    @ArgumentParser.Flag(help: "Compile the files in 'source' as a library instead of an executable. Compiling as library will produce '.hmax' files in '_target'. NOTE: This functionality is *NOT* finished yet, and correct results are therefore not guaranteed.")
    private var asLibrary: Bool = false
    
    @ArgumentParser.Flag(help: "Print profiling information. Get timing information about each part of the compilation process.")
    private var profile: Bool = false
    
    
    // MARK: the run() method
    
    
    func run() throws {
        
        let compiler = Compiler(self.libPaths)
        
        if profile {
            compiler.addFileOption(nil, .profile)
        }
        
        setOutputInformation(compiler)
        compile(compiler)
        
    }
    
    
    // MARK: Private helper methods
    
    
    private func assembleSourceCode() throws -> [String] {
        
        let sourceFolder = current + "/" + MainDefaults.sourceSubPath
        
        let allContent = deepSearch(sourceFolder, .collect(predicate: { $0.hasSuffix(".pmax") }))
        
        return allContent
        
    }
    
    
    private func setOutputInformation(_ compiler: Compiler) {
        
        let targetName = TargetDefaults.name(self.targetName, asLibrary)
        
        let outPath: String = current + "/_targets/" + targetName
        let outOption: DebugOption = asLibrary ? .libraryCode : .assemblyCode
        
        compiler.addFileOption(outPath, outOption)
        
    }
    
    
    private func compile(_ compiler: Compiler) {
        
        do {
            
            let sourceCode = try assembleSourceCode()
            try compiler.compile(sourceCode, asLibrary)
            compiler.printErrors()
            
        } catch {
            
            print(error)
            return
            
        }
        
    }
    
    
}

