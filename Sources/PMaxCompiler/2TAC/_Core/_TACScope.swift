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
        self.framePointerOffset = 1
        
    }
    
    init(_ parent: TACScope) {
        
        self.parent = parent
        self.lowerer = parent.lowerer
        self.dataSectionCounter = parent.dataSectionCounter
        self.framePointerOffset = parent.framePointerOffset
        
    }
    
    @discardableResult
    func declare(_ type: PILType, _ name: String) -> Location {
        
        let location = Location.framePointer(offset: framePointerOffset)
        variables[name] = (type, location)
        framePointerOffset += lowerer.sizeOf(type)
        
        printIfAllowed("\(type) \(name)", 40, "@ \(location)")
        
        return location
        
    }
    
    /// Recursively search all scopes to check if a variable with a given name exists. Used when declaring new literals.
    func variableExists(_ name: String) -> Bool {
        
        if variables[name] != nil {
            return true
        }
        
        if let parent {
            return parent.variableExists(name)
        }
        
        return false
        
    }
    
    func getVariable(_ name: String) -> (type: PILType, location: Location) {
        
        // SKAL eksistere, ellers har noe gått galt.
        guard let v = variables[name] else {
            return parent!.getVariable(name)
        }
        
        return v
        
    }
    
    private func printIfAllowed(_ left: String, _ beginRight: Int, _ right: String) {
        
        guard Compiler.allowPrinting else {
            return
        }
        
        let message = left + String(repeating: " ", count: beginRight - left.count) + right
        print(message)
        
    }
    
}
