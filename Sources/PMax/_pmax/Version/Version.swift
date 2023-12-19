
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2023-12-19"
        let version = "0.5.2"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
