import ArgumentParser

struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2023-12-13"
        let version = "0.4.2"
        
        print("PMax Compiler\n\tVersion \(version)\n\t\(date)")
        
    }
    
}
