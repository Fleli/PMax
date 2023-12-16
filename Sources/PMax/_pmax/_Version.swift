
import ArgumentParser


struct Version: ParsableCommand {
    
    func run() throws {
        
        let date = "2023-12-14"
        let version = "0.4.7"
        
        print("Version \(version)\n\(date)")
        
    }
    
}
