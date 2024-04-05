extension PILType {
    
    
    func size(_ lowerer: PILLowerer, _ structSearchHistory: Set<PILStruct>) -> Int? {
        
        switch self {
            
        case .error, .void:
            return 0
        case .int, .char, .pointer(_), .function(_, _):
            return 1
        case .struct(let name):
            return lowerer.structs[name]?.memoryLayout(lowerer, structSearchHistory)?.size
            
        }
        
    }
    
    
}
