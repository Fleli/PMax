class TACScope {
    
    let parent: TACScope?
    
    private var textSectionCounter: Int
    private var framePointerOffset: Int
    
    private var variables: [String : (PILType, Location)] = [:]
    
    private weak var lowerer: TACLowerer!
    
    init(_ lowerer: TACLowerer) {
        self.parent = nil
        self.lowerer = lowerer
        self.textSectionCounter = 0
        self.framePointerOffset = 0
    }
    
    init(_ parent: TACScope) {
        self.parent = parent
        self.lowerer = parent.lowerer
        self.textSectionCounter = parent.textSectionCounter
        self.framePointerOffset = parent.framePointerOffset
    }
    
    func declare(_ type: PILType, _ name: String) {
        print("Declared \(name) @ \(framePointerOffset)")
        variables[name] = (type, .framePointer(offset: framePointerOffset))
        framePointerOffset += lowerer.sizes(type)
    }
    
    func declareInTextSection(_ type: PILType, _ name: String) {
        print("Declared \(name) in text section @ \(textSectionCounter).")
        variables[name] = (type, .textSegment(index: textSectionCounter))
        // TODO: This must be changed in future versions when non-int literals become allowed.
        textSectionCounter += 1
    }
    
    func getVariable(_ name: String) -> (PILType, Location) {
        // SKAL eksistere, ellers har noe gått galt.
        return variables[name]!
    }
    
}
