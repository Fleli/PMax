class TACLowerer: ErrorReceiver {
    
    
    var local: PILScope!
    
    var activeLabel: Label!
    
    private var labels: [Label] = []
    
    private var internalCounter = 0
    
    private(set) var errors: [PMaxError] = []
    
    private(set) var functions: [String : PILFunction] = [:]
    
    init(_ pilLowerer: PILLowerer) {
        
        self.local = PILScope(self)
        
        self.functions = pilLowerer.functions
        
    }
    
    
    func lower() {
        
        print("\n\n")
        
        for function in functions.values {
            
            let newLabel = newLabel("fn=\(function.name)")
            activeLabel = newLabel
            
            for statement in function.body {
                statement.lowerToTAC(self)
            }
            
        }
        
        for label in labels {
            print(label)
        }
        
    }
    
    
    func submitError(_ newError: PMaxError) {
        errors.append(newError)
    }
    
    
    /// Create a new label named within the given `context`. Will return the label, but **won't use it as the new active label.** Doing so is up to the caller.
    func newLabel(_ context: String) -> Label {
        
        internalCounter += 1
        
        let newLabel = Label("$label\(internalCounter):\(context)")
        labels.append(newLabel)
        
        return newLabel
        
    }
    
    
    /// Generate (and declare) a new internal variable. It does not collide with any other variable names. It uses a `context` parameter to give a _somewhat_ informative name.
    func newInternalVariable(_ context: String, _ type: PILType) -> String {
        
        internalCounter += 1
        
        let name = "$$\(internalCounter)"
        local.declare(type, name)
        
        return name
        
    }
    
    
}
