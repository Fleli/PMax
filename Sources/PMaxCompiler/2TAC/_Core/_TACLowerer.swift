class TACLowerer {
    
    var global: TACScope!
    var local: TACScope!
    
    var activeLabel: Label!
    
    private let pilLowerer: PILLowerer
    
    private var labels: [Label] = []
    
    private var internalCounter = 0
    
    private(set) var errors: [PMaxError] = []
    
    private var structs: [String : PILStruct] = [:]
    
    private(set) var functions: [String : PILFunction] = [:]
    
    init(_ pilLowerer: PILLowerer) {
        
        print("\n\n")
        
        self.pilLowerer = pilLowerer
        self.structs = pilLowerer.structs
        self.functions = pilLowerer.functions
        
        self.global = TACScope(self)
        self.local = global
        
        registerGlobalVariables()
        
    }
    
    
    private func registerGlobalVariables() {
        
        for globalVariable in pilLowerer.global.variables {
            
            let name = globalVariable.key
            let type = globalVariable.value
            
            guard case .int = type else {
                fatalError("Global variables can only be 'int', not '\(type)'.")
            }
            
            global.declareInDataSection(type, name)
            
        }
        
    }
    
    
    func lower() {
        
        for function in functions.values {
            
            push()
            
            let newLabel = newLabel("fn=\(function.name)")
            activeLabel = newLabel
            
            for statement in function.body {
                statement.lowerToTAC(self)
            }
            
            pop()
            
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
    func newInternalVariable(_ context: String, _ type: PILType) -> Location {
        internalCounter += 1
        let name = "$$\(internalCounter)"
        return local.declare(type, name)
    }
    
    
    func sizeOf(_ type: PILType) -> Int {
        
        switch type {
        case .int, .pointer(_):
            return 1
        case .void, .error:
            return 0
        case .struct(let name):
            return pilLowerer.structLayouts[name]!.size
        }
        
    }
    
    
    func push() {
        local = TACScope(local)
    }
    
    func pop() {
        local = local.parent!
    }
    
    
}
