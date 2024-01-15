
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-01-14"
        let version = "0.6.3"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
