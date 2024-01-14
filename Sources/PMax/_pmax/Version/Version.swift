
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-01-13"
        let version = "0.6.2"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
