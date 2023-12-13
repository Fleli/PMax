import ArgumentParser
import Foundation

struct Build: ParsableCommand {
    
    @ArgumentParser.Argument(help: "The file to compile.")
    private var file: String
    
    @ArgumentParser.Flag(help: "Output the intermediate TAC.")
    private var tac: Bool = false
    
    @ArgumentParser.Flag(help: "Output the intermediate PIL.")
    private var pil: Bool = false
    
    @ArgumentParser.Flag(name: .short, help: "Assemble and run the generated output on a virtual machine.")
    private var r: Bool = false
    
    @ArgumentParser.Option(help: "Specify the paths for the compiler to search for libraries in.")
    private var libPaths: [String] = []
    
    @ArgumentParser.Option(help: "Generate a text file with profiling statistics.")
    private var profile: String?
    
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
        
        if pil {
            let pilOption = FileOption(currentDirectory + "/out.pmaxpil", .pmaxIntermediateLanguage)
            compiler.addFileOption(pilOption)
        }
        
        if tac {
            let tacOption = FileOption(currentDirectory + "/out.pmaxtac", .threeAddressCode)
            compiler.addFileOption(tacOption)
        }
        
        if let profile {
            let profileOption = FileOption(currentDirectory + "/" + profile, .profile)
            compiler.addFileOption(profileOption)
        }
        
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
            
            if r {
                print("Missing suitable assembler and virtual machine.")
            }
            
        } catch {
            
            print(error)
            return
            
        }
        
    }
    
}

