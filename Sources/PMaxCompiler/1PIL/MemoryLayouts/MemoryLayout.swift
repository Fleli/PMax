struct MemoryLayout {
    
    
    /// The total size of instances of this struct
    private(set) var size: Int
    
    /// The frame pointer offset and type size for each field.
    private(set) var fields: [String : (start: Int , length: Int)]
    
    
    init() {
        self.size = 0
        self.fields = [:]
    }
    
    
    mutating
    func addField(_ name: String, _ size: Int) {
        fields[name] = (start: self.size, length: size)
        self.size += size
    }
    
    
}
