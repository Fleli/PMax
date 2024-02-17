
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-02-05"
        let version = "0.7.1"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
