class TACLowerer: CustomStringConvertible {
    
    var global: TACScope!
    var local: TACScope!
    
    var activeLabel: Label!
    
    let pilLowerer: PILLowerer
    
    private var internalCounter = 0
    
    private var structs: [String : PILStruct] = [:]
    
    private(set) var functionLabels: [String : Label] = [:]
    
    private(set) var functions: [String : PILFunction] = [:]
    
    private(set) var labels: [Label] = []
    
    private(set) var errors: [PMaxError] = []
    
    init(_ pilLowerer: PILLowerer) {
        
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
        
        for function in functions {
            
            let function = function.value
            
            let newLabel = newLabel("fn_\(function.name)")
            functionLabels[function.name] = newLabel
            
        }
        
        var containsValidMain = false
        
        for function in functions.values {
            
            push()
            
            if function.name == "main" && function.type == .int && function.parameters.count == 0 {
                containsValidMain = true
            }
            
            for parameter in function.parameters {
                local.declare(parameter.type, parameter.label)
            }
            
            activeLabel = functionLabels[function.name]!
            
            for statement in function.body {
                statement.lowerToTAC(self)
            }
            
            pop()
            
        }
        
        if !containsValidMain {
            submitError(.hasNoValidMain)
        }
        
        let mainLabel = Label("__main")
        let fnMainLabel = functionLabels["main"]!
        mainLabel.newStatement(.jump(label: fnMainLabel.name))
        labels.insert(mainLabel, at: 0)
        
        guard Compiler.allowPrinting else {
            return
        }
        
        print("\n\nRESULT FROM LOWERING TO THREE-ADDRESS CODE (TAC):\n")
        
        for label in labels {
            print(label.description)
        }
        
        print("\n")
        
    }
    
    
    func submitError(_ newError: PMaxError) {
        errors.append(newError)
    }
    
    
    /// Create a new label named within the given `context`. Will return the label, but **won't use it as the new active label.** Doing so is up to the caller.
    func newLabel(_ context: String) -> Label {
        
        internalCounter += 1
        
        let newLabel = Label("label\(internalCounter)_\(context)")
        labels.append(newLabel)
        
        return newLabel
        
    }
    
    
    /// Generate (and declare) a new internal variable. It does not collide with any other variable names. It uses a `context` parameter to give a _somewhat_ informative name.
    func newInternalVariable(_ context: String, _ type: PILType) -> Location {
        internalCounter += 1
        let name = "$\(internalCounter)"
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
    
    var description: String {
        
        return labels.reduce("", {$0 + $1.description + "\n"})
        
    }
    
}
