extension String {
    
    func build(_ instruction: String, _ comment: String?) -> String {
        
        var instruction = "\t" + instruction
        
        if let comment {
            let missing = 50 - instruction.count
            let spacing = String(repeating: " ", count: missing)
            instruction += spacing + "; " + comment
        }
        
        return self + instruction + "\n"
        
    }
    
}
