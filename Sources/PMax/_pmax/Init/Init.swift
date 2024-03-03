
import Foundation
import ArgumentParser


struct Init: ParsableCommand {
    
    
    // MARK: Private variables
    
    
    private var workingDirectory = FileManager().currentDirectoryPath
    
    
    // MARK: Command-line arguments, options and flags
    
    
    @ArgumentParser.Option(help: "Specify the author.")
    var author: String?
    
    @ArgumentParser.Option(help: "Specify the name of the output file.")
    private var targetName: String?
    
    @ArgumentParser.Flag(help: "Initialize as a library with a given name.")
    var asLibrary: Bool = false
    
    
    // MARK: The run() method
    
    
    func run() throws {
        
        try newFolder("_targets")
        try newFolder(MainDefaults.sourceSubPath)
        
        let target = TargetDefaults.name(targetName, asLibrary)
        newFile("Makefile", MakefileDefault.text(target, asLibrary))
        
        createMainFile()
        
    }
    
    
    // MARK: Private helper methods
    
    
    private func newFolder(_ name: String) throws {
        try FileManager().createDirectory(atPath: workingDirectory + "/" + name, withIntermediateDirectories: false)
    }
    
    
    private func newFile(_ path: String, _ contents: String? = nil) {
        
        let successful = FileManager().createFile(atPath: path, contents: contents?.data(using: .utf8))
        
        if !successful {
            print("Creating file @ \(path) failed.")
        }
        
    }
    
    
    private func createMainFile() {
        
        let path = MainDefaults.sourceSubPath + "/main.pmax"
        let content = MainDefaults.mainPMaxDefault(author, asLibrary)
        
        newFile(path, content)
        
    }
    
    
}
