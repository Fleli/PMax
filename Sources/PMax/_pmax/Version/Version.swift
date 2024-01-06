
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-01-05"
        let version = "0.5.4"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
