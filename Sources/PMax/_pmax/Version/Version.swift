
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2024-02-03"
        let version = "0.7.0"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
