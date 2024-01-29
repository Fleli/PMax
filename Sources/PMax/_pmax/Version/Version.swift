
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-01-29"
        let version = "0.6.5"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
