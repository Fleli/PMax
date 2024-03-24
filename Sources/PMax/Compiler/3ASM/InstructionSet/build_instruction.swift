extension String {
    
    static var includeCommentsInAssembly = false
    
    func build(_ instruction: String, _ comment: String?) -> String {
        
        var instruction = "\t" + instruction
        
        if Self.includeCommentsInAssembly, let comment {
            let missing = 50 - instruction.count
            let spacing = String(repeating: " ", count: max(1, missing))
            instruction += spacing + "; " + comment
        }
        
        return self + instruction + "\n"
        
    }
    
}
