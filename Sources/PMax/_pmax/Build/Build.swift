
import ArgumentParser
import Foundation


struct Build: ParsableCommand {
    
    
    // MARK: Private variables
    
    
    private var current = Foundation.FileManager().currentDirectoryPath
    
    
    // MARK: Command-line
    
    
    @ArgumentParser.Option(help: "Specify the paths for the compiler to search for libraries in.")
    private var libPaths: [String] = []
    
    @ArgumentParser.Option(help: "Specify the name of the output file. Do not include file extensions - only provide the actual name.")
    private var targetName: String?
    
    @ArgumentParser.Flag(help: "Compile the files in 'source' as a library instead of an executable. Compiling as library will produce '.hmax' files in '_target'. NOTE: This functionality is *NOT* finished yet, and correct results are therefore not guaranteed.")
    private var asLibrary: Bool = false
    
    @ArgumentParser.Flag(help: "Print profiling information. Get timing information about each part of the compilation process.")
    private var profile: Bool = false
    
    @ArgumentParser.Flag(help: "Emit frame pointer offsets for all variables (both declared explicitly and generated by the compiler).")
    private var emitOffsets: Bool = false
    
    @ArgumentParser.Flag(help: "Emit full PIL (PMax Intermediate Language) information.")
    private var emitPil: Bool = false
    
    @ArgumentParser.Flag(help: "Emit full TAC (Three-Address Code) information.")
    private var emitTac: Bool = false
    
    @ArgumentParser.Flag(help: "Include TAC comments and assembly explanations in the resulting assembly file.")
    private var includeComments: Bool = false
    
    // MARK: The run() method
    
    
    func run() throws {
        
        String.includeCommentsInAssembly = self.includeComments
        
        let compiler = Compiler(libPaths)
        
        handleFlags(compiler)
        setOutputInformation(compiler)
        try compile(with: compiler)
        
    }
    
    
    // MARK: Private helper methods
    
    
    private func handleFlags(_ compiler: Compiler) {
        
        if profile {
            compiler.addFileOption(nil, .profile)
        }
        
        if emitPil {
            compiler.addFileOption(nil, .pmaxIntermediateLanguage)
        }
        
        if emitTac {
            compiler.addFileOption(nil, .threeAddressCode)
        }
        
    }
    
    
    private func assembleSourceCode() throws -> [String] {
        
        let sourceFolder = current + "/" + MainDefaults.sourceSubPath
        
        let allContent = deepSearch(sourceFolder, .collect(predicate: { $0.hasSuffix(".pmax") }))
        
        return allContent
        
    }
    
    
    private func setOutputInformation(_ compiler: Compiler) {
        
        let targetName = TargetDefaults.name(self.targetName, asLibrary)
        
        let outPath: String = current + "/_targets/" + targetName + (asLibrary ? ".hmax" : ".bba")
        let outOption: DebugOption = asLibrary ? .libraryCode : .assemblyCode
        
        compiler.addFileOption(outPath, outOption)
        
    }
    
    
    private func compile(with compiler: Compiler) throws {
        
        let sourceCode = try assembleSourceCode()
        try compiler.compile(sourceCode, asLibrary, emitOffsets)
        
    }
    
    
}

