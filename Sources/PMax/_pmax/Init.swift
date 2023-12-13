import Foundation
import ArgumentParser

// TODO: Add support for library initialization
// For now, initialization with the 'init' subcommand is "user-oriented"
// It assumes someone is building an application, using libraries
// Support for library initialization for actually writing libraries will come later.

struct Init: ParsableCommand {
    
    
    @ArgumentParser.Option(help: "Specify the author.")
    var author: String?
    
    
    private var workingDirectory = FileManager().currentDirectoryPath
    
    
    func run() throws {
        
        print("Init new PMax repository")
        
        try newFolder("_libraries")
        try newFolder("_targets")
        try newFolder(Shared.sourcePath)
        
        newFile("Makefile", Shared.makefileDefault)
        newFile("source/main.pmax", Shared.mainPMaxDefault(name: author))
        
    }
    
    private func newFolder(_ name: String) throws {
        
        try FileManager().createDirectory(atPath: workingDirectory + "/" + name, withIntermediateDirectories: false)
        
    }
    
    private func newFile(_ name: String, _ contents: String? = nil) {
        
        let successful = FileManager().createFile(atPath: workingDirectory + "/" + name, contents: contents?.data(using: .utf8))
        
        if !successful {
            print("Creating file \(name) failed.")
        }
        
    }
    
}
