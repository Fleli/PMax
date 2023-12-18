import Foundation

class CompilerProfiler: CustomStringConvertible {
    
    
    var prev: UInt64
    var results: [ProfileResult] = []
    
    
    var description: String {
        results.reduce("\nCOMPILER TIMING MEASUREMENTS (PROFILING RESULTS)\n------------------------------------------------\n") {$0 + $1.description + "\n"} + "\n"
    }
    
    
    init() {
        self.prev = DispatchTime.now().uptimeNanoseconds
    }
    
    
    func register(_ result: DebugOption) {
        
        let now = DispatchTime.now().uptimeNanoseconds
        let time = (now - prev) / 1_000_000
        
        let profileResult = ProfileResult(time, result)
        results.append(profileResult)
        
        prev = now
        
    }
    
    
}

struct ProfileResult: CustomStringConvertible {
    
    
    let time: UInt64
    let result: DebugOption
    
    
    var description: String {
        let timeDescription = "\(time)"
        return timeDescription + String(repeating: " ", count: 6 - timeDescription.count) + "ms   \(result)"
    }
    
    
    init(_ time: UInt64, _ result: DebugOption) {
        self.time = time
        self.result = result
    }
    
}


