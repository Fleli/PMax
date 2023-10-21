extension AssemblyLowerer {
    
    static let stackPointerAddress = 0x4000
    
    static func load_register_with_value(at location: Location, register index: Int) -> String {
        
        guard 0 <= index  &&  index <= 7 else {
            fatalError("Register index cannot be \(index).")
        }
        
        var assembly = ""
        
        switch location {
        case .framePointer(let offset):
            return ""
                .ld(index, stackPointerAddress, "fetch stack pointer")
                .addi(index, index, offset, "address of local variable")
        case .dataSection(let index):
            break
        case .rawPointer(let offset):
            break
        }
        
        return assembly
        
    }
    
    
    
    
    
    
}
