
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-02-17"
        let version = "0.7.2"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
