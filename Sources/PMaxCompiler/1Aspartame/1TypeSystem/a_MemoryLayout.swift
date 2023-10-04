class MemoryLayout {
    
    private(set) var pointer = 0
    
    private(set) var members: [String : StructMember] = [:]
    
    func addMember(_ name: String, _ type: DataType, _ size: Int) {
        let member = StructMember(type: type, framePointerOffset: pointer)
        members[name] = member
        pointer += size
    }
    
}

// TODO: Undersøk om denne egentlig faktisk representerer mer enn bare struct members. Det å ha en offset og en type er kanskje felles for alle referanser?
struct StructMember {
    
    let type: DataType
    let framePointerOffset: Int
    
}
