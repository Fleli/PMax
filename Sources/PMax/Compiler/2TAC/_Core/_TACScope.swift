class TACScope {
    
    let parent: TACScope?
    
    private var emitOffsets: Bool
    
    private var dataSectionCounter: Int
    private var framePointerOffset: Int
    
    private var variables: [String : (type: PILType, framePointerOffset: Int)] = [:]
    
    private weak var lowerer: TACLowerer!
    
    init(_ lowerer: TACLowerer, _ emitOffsets: Bool) {
        
        self.parent = nil
        self.lowerer = lowerer
        self.dataSectionCounter = 0
        self.framePointerOffset = 1
        self.emitOffsets = emitOffsets
        
    }
    
    init(_ parent: TACScope) {
        
        self.parent = parent
        self.lowerer = parent.lowerer
        self.dataSectionCounter = parent.dataSectionCounter
        self.framePointerOffset = parent.framePointerOffset
        self.emitOffsets = parent.emitOffsets
        
    }
    
    /// Declare a new variable in this scope. Return the new variable's frame pointer offset.
    @discardableResult
    func declare(_ type: PILType, _ name: String) -> Int {
        
        /// Represents the frame pointer offset of the newly declared variable.
        let offset = framePointerOffset
        
        /// Represents the size of the newly declared variable, in words (number of addresses).
        let typeSize = lowerer.sizeOf(type)
        
        // Increment the frame pointer so that the next variable is declared just after this one.
        framePointerOffset += typeSize
            
        // Store the newly declared variable.
        variables[name] = (type, offset)
        
        // Obey command-line requests.
        if emitOffsets {
            var decl = type.description + " " + name + ";"
            decl += String(repeating: " ", count: max(0, 35 - decl.count))
            decl += "fp + \(offset)"
            decl += String(repeating: " ", count: max(0, 55 - decl.count))
            decl += "\(typeSize) words"
            print("\t" + decl)
        }
        
        // Retun the frame pointer offset of the new variable.
        return offset
        
    }
    
    func getVariableAsLValue(_ name: String) -> LValue {
        
        guard let local = variables[name] else {
            return parent!.getVariableAsLValue(name)
        }
        
        return .stackAllocated(framePointerOffset: local.1)
        
    }
    
}
