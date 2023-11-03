extension PILStruct: Hashable {
    
    
    func memoryLayout(_ lowerer: PILLowerer, _ history: Set<PILStruct> = []) -> MemoryLayout? {
        
        var layout = MemoryLayout()
        
        if history.contains(self) {
            lowerer.submitError(PMaxIssue.structIsRecursive(structName: name))
            return nil
        }
        
        let history = history.union([self])
        
        for field in sortedFields {
            
            let type = fields[field]
            
            guard let size = type?.size(lowerer, history) else {
                return nil
            }
            
            layout.addField(field, size)
            
        }
        
        return layout
        
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    
    static func == (lhs: PILStruct, rhs: PILStruct) -> Bool {
        return lhs === rhs
    }
    
    
}
