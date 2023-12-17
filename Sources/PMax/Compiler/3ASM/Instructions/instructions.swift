extension String {
    
    /// Load from a raw address
    func ldraw(_ register: Int, _ rawAddress: Int, _ comment: String? = nil) -> String {
        build("ldraw r\(register), \(rawAddress)", comment)
    }
    
    /// Load immediate value
    func li(_ register: Int, _ immediate: Int, _ comment: String? = nil) -> String {
        build("li r\(register), \(immediate)", comment)
    }
    
    /// Copy (move) the value in `src` to `dst`.
    func mv(_ dst: Int, _ src: Int, _ comment: String? = nil) -> String {
        if dst == src {
            build("", (comment == nil) ? nil : comment! + " [Optimization: Moving from r\(src) to r\(dst)]")
        } else {
            build("mv r\(dst), r\(src)", comment)
        }
    }
    
    /// Add immediate
    func addi(_ dst: Int, _ src: Int, _ imm: Int, _ comment: String? = nil) -> String {
        
        if imm == 0 {
            return mv(dst, src, comment == nil ? nil : comment! + " [Optimization: r\(src) + 0 == r\(src)]")
        } else {
            return build("addi r\(dst), r\(src), \(imm)", comment)
        }
        
    }
    
    /// Load indirect.
    func ldind(_ dst: Int, _ addressRegister: Int, _ comment: String? = nil) -> String {
        build("ldind r\(dst), r\(addressRegister)", comment)
    }
    
    /// The following pattern often occurs:
    /// add offset to stack pointer -> load at that address -> manipulate data -> store at some offset from stack pointer
    /// The `ldio` and `stio` instructions combine `sp` offsetting with `load` and `store` operations, which helps eliminate cycles.
    
    /// Add an immediate to a register and treat this sum as an address. Load the data at this address. (`LoaD Immediate Offset`)
    func ldio(_ dst: Int, _ src: Int, _ imm: Int, _ comment: String? = nil) -> String {
        
        if imm == 0 {
            return ldind(dst, src, comment == nil ? nil : comment! + " [Optimization: r\(src) + 0 == r\(src)]")
        } else {
            return build("ldio r\(dst), r\(src), \(imm)", comment)
        }
        
    }
    
    /// Add an immediate to a register and treat this sum as an address. Store the data in `rd` at this address. (`STore Immediate Offset`)
    func stio(_ rs: Int, _ imm: Int, _ rd: Int, _ comment: String? = nil) -> String {
        build("stio r\(rs), \(imm), r\(rd)", comment)
    }
    
    /// Store the value in register `valAddress` at the raw address pointed to by the `dstAddress` register.
    func st(_ dstAddress: Int, _ valAddress: Int, _ comment: String? = nil) -> String {
        build("st r\(dstAddress), r\(valAddress)", comment)
    }
    
    /// Perform an addition on the operands `srcA` and `srcB`. Store the result in `dst`.
    func add(_ dst: Int, _ srcA: Int, _ srcB: Int, _ comment: String? = nil) -> String {
        build("add r\(dst), r\(srcA), r\(srcB)", comment)
    }
    
    /// Perform a subtraction on the operands `srcA` and `srcB`. Store the result in `dst`.
    func sub(_ dst: Int, _ srcA: Int, _ srcB: Int, _ comment: String? = nil) -> String {
        build("sub r\(dst), r\(srcA), r\(srcB)", comment)
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
        build("call \(callee), \(returnLabel)", comment)
    }
    
    /// Perform an unconditional jump to the address stored in `rawAddressRegister`
    func j(_ rawAddressRegister: Int, _ comment: String? = nil) -> String {
        build("j r\(rawAddressRegister)", comment)
    }
    
    /// Jump if a certain register is _not_ equal to zero.
    func jnz(_ register: Int, _ label: String, _ comment: String? = nil) -> String {
        build("jnz r\(register), \(label)", comment)
    }
    
    /// Shift right
    func sr(_ dst: Int, _ src: Int, _ comment: String) -> String {
        build("sr r\(dst), r\(src)", comment)
    }
    
}
