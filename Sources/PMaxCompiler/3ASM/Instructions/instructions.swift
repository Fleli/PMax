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
        build("addi r\(dst), r\(src), \(imm)", comment)
    }
    
    /// Load with register as address
    func ldfr(_ dst: Int, _ addressRegister: Int, _ comment: String? = nil) -> String {
        build("ldfr r\(dst), r\(addressRegister)", comment)
    }
    
    /// Store the value in register `valAddress` at the raw address pointed to by the `dstAddress` register.
    func st(_ dstAddress: Int, _ valAddress: Int, _ comment: String? = nil) -> String {
        build("st r\(dstAddress), r\(valAddress)", comment)
    }
    
    /// Perform an addition on the operands `srcA` and `srcB`. Store the result in `dst`.
    func add(_ dst: Int, _ srcA: Int, _ srcB: Int, _ comment: String? = nil) -> String {
        build("add r\(dst), r\(srcA) r\(srcB)", comment)
    }
    
    /// Perform a subtraction on the operands `srcA` and `srcB`. Store the result in `dst`.
    func sub(_ dst: Int, _ srcA: Int, _ srcB: Int, _ comment: String? = nil) -> String {
        build("sub r\(dst), r\(srcA) r\(srcB)", comment)
    }
    
    /// Perform a bitwise `NOT` on the operand `src`. Store the result in `dst`.
    func not(_ dst: Int, _ src: Int, _ comment: String? = nil) -> String {
        build("not r\(dst), r\(src)", comment)
    }
    
    /// Perform a negation on the operand `src`. Store the result in `dst`.
    func neg(_ dst: Int, _ src: Int, _ comment: String? = nil) -> String {
        build("neg r\(dst), r\(src)", comment)
    }
    
    /// Tell the assembler to call a function and to which label it should return afterwards. The assembler calculates the raw return address and inserts code to store this address at `[fp - 1]`.
    func call(_ callee: String, _ returnLabel: String, _ comment: String? = nil) -> String {
        build("call \(callee) -> \(returnLabel)", comment)
    }
    
    /// Perform an unconditional jump to the address stored in `rawAddressRegister`
    func j(_ rawAddressRegister: Int, _ comment: String? = nil) -> String {
        build("j r\(rawAddressRegister)", comment)
    }
    
}
