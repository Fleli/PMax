
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-01-11"
        let version = "0.6.1"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
