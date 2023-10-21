extension String {
    
    /// Load from immediate address
    func ld(_ register: Int, _ rawAddress: Int, _ comment: String? = nil) -> String {
        build("ld r\(register), \(rawAddress)", comment)
    }
    
    /// Load immediate value
    func li(_ register: Int, _ immediate: Int, _ comment: String? = nil) -> String {
        build("li r\(register), \(immediate)", comment)
    }
    
    /// Add immediate
    func addi(_ dst: Int, _ src: Int, _ imm: Int, _ comment: String? = nil) -> String {
        build("addi r\(dst), r\(dst), \(imm)", comment)
    }
    
    /// Load with register as address
    func ldfr(_ dst: Int, _ addressRegister: Int, _ comment: String? = nil) -> String {
        build("ldfr r\(dst), r\(addressRegister)", comment)
    }
    
    private func build(_ instruction: String, _ comment: String?) -> String {
        
        var instruction = "\t" + instruction
        
        if let comment {
            let missing = 50 - instruction.count
            let spacing = String(repeating: " ", count: missing)
            instruction += spacing + "; " + comment
        }
        
        return instruction + "\n"
        
    }
    
    
}
