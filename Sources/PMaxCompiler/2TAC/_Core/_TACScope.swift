class TACScope {
    
    let parent: TACScope?
    
    private var dataSectionCounter: Int
    private var framePointerOffset: Int
    
    private var variables: [String : (PILType, Location)] = [:]
    
    private weak var lowerer: TACLowerer!
    
    init(_ lowerer: TACLowerer) {
        self.parent = nil
        self.lowerer = lowerer
        self.dataSectionCounter = 0
        self.framePointerOffset = 0
    }
    
    init(_ parent: TACScope) {
        self.parent = parent
        self.lowerer = parent.lowerer
        self.dataSectionCounter = parent.dataSectionCounter
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
    
    func declareInDataSection(_ type: PILType, _ name: String) {
        print("Declared \(name) in text section @ \(dataSectionCounter).")
        variables[name] = (type, .dataSection(index: dataSectionCounter))
        dataSectionCounter += lowerer.sizeOf(type)
    }
    
    func getVariable(_ name: String) -> (PILType, Location) {
        // SKAL eksistere, ellers har noe gått galt.
        guard let v = variables[name] else {
            return parent!.getVariable(name)
        }
        
        return v
        
    }
    
}
