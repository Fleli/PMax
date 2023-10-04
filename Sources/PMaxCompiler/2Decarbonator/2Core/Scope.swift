class Scope {
    
    let aspartame: Aspartame
    let decarbonator: Decarbonator
    
    var framePointerOffset: Int
    var declarations: [String : DecarbonatedDeclaration] = [:]
    
    private let parent: Scope?
    
    init(_ parent: Scope) {
        self.parent = parent
        self.aspartame = parent.aspartame
        self.decarbonator = parent.decarbonator
        self.framePointerOffset = parent.framePointerOffset
    }
    
    init(_ decarbonator: Decarbonator, _ aspartame: Aspartame) {
        self.parent = nil
        self.framePointerOffset = 0
        self.aspartame = aspartame
        self.decarbonator = decarbonator
    }
    
    func framePointerOffset(_ lhs: String) -> Int? {
        return declarations[lhs]?.framePointerOffset
    }
    
    func type(_ lhs: String) -> DataType? {
        return declarations[lhs]?.type
    }
    
    func inferType(of lhs: String, to type: DataType) {
        
        guard let lhsOffset = framePointerOffset(lhs) else {
            fatalError("Should be able to find offset of \(lhs) with declarations = \(declarations)")
        }
        
        declarations[lhs] = DecarbonatedDeclaration(type, lhsOffset)
        framePointerOffset += type.size(aspartame, [])
        
    }
    
    func fetchVariable(_ name: String) -> DecarbonatedDeclaration? {
        
        guard let variable = declarations[name] else {
            decarbonator.submitError(.variableDoesNotExist(name: name))
            return nil
        }
        
        return variable
        
    }
    
}

struct DecarbonatedDeclaration {
    
    let type: DataType
    let framePointerOffset: Int
    
    init(_ type: DataType, _ framePointerOffset: Int) {
        self.type = type
        self.framePointerOffset = framePointerOffset
    }
    
}
