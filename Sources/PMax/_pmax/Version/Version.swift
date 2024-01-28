
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-01-15"
        let version = "0.6.4"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
