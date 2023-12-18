
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2023-12-18"
        let version = "0.5.0"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
