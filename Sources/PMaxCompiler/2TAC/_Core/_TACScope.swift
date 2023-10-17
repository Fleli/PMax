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
    
    @discardableResult
    func declare(_ type: PILType, _ name: String) -> Location {
        print("Declared \(name) @ \(framePointerOffset)")
        let location = Location.framePointer(offset: framePointerOffset)
        variables[name] = (type, location)
        framePointerOffset += lowerer.sizeOf(type)
        return location
    }
    
    func declareInTextSection(_ type: PILType, _ name: String) {
        print("Declared \(name) in text section @ \(textSectionCounter).")
        variables[name] = (type, .textSegment(index: textSectionCounter))
        textSectionCounter += lowerer.sizeOf(type)
    }
    
    func getVariable(_ name: String) -> (PILType, Location) {
        // SKAL eksistere, ellers har noe gått galt.
        guard let v = variables[name] else {
            return parent!.getVariable(name)
        }
        
        return v
        
    }
    
}
