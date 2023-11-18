class TACLowerer: CustomStringConvertible {
    
    var local: TACScope!
    
    var activeLabel: Label!
    
    let pilLowerer: PILLowerer
    
    var noIssues: Bool {
        return errors.reduce(true, {$0 && $1.allowed})
    }
    
    private var internalCounter = 0
    
    private var structs: [String : PILStruct] = [:]
    
    private var internalFunctionLabels: [String : Label] = [:]
    private var externalFunctionLabels: [String : String] = [:]
    
    private(set) var functions: [String : PILFunction] = [:]
    
    private(set) var labels: [Label] = []
    
    private(set) var libraryAssembly: [String] = []
    
    private(set) var errors: [PMaxError] = []
    
    init(_ pilLowerer: PILLowerer) {
        
        self.pilLowerer = pilLowerer
        self.structs = pilLowerer.structs
        self.functions = pilLowerer.functions
        
        self.local = TACScope(self)
        
    }
    
    
    func lower() {
        
        for function in functions {
            
            let function = function.value
            
            if case .external(let assembly, let entry) = function.body {
                
                libraryAssembly.append(assembly)
                externalFunctionLabels[function.name] = entry
                
            } else {
                
                let entry = function.entryLabelName()
                let newLabel = newLabel(entry, true)
                internalFunctionLabels[function.name] = newLabel
                
            }
            
        }
        
        var containsValidMain = false
        
        for function in functions.values {
            
            let body = function.body
            
            guard case .pmax(_, let lowered) = body else {
                continue
            }
            
            push()
            
            if function.name == "main" && function.type == .int && function.parameters.count == 0 {
                containsValidMain = true
            }
            
            for parameter in function.parameters {
                local.declare(parameter.type, parameter.label)
            }
            
            activeLabel = internalFunctionLabels[function.name]!
            
            for statement in lowered {
                statement.lowerToTAC(self)
            }
            
            pop()
            
        }
        
        if !containsValidMain {
            submitError(.hasNoValidMain)
        }
        
        let mainLabel = Label("__main")
        let fnMainLabel = internalFunctionLabels["main"]!
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
    
    
    func submitError(_ newError: PMaxIssue) {
        errors.append(newError)
    }
    
    
    /// Create a new label. If `isFunctionEntry` (if this is the label jumped to when calling a function), its name is the `context`. For other labels used in `if`s etc., an internal counter makes sure no names clash, and just uses the context to give the label an informative name.
    func newLabel(_ context: String, _ isFunctionEntry: Bool) -> Label {
        
        let newLabel: Label
        
        if isFunctionEntry {
            newLabel = Label(context)
        } else {
            internalCounter += 1
            newLabel = Label("l\(internalCounter)_\(context)")
        }
        
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
        labels.reduce("", {$0 + $1.description + "\n"})
    }
    
    func getFunctionEntryPoint(_ function: String) -> String {
        
        if let internalFunction = internalFunctionLabels[function] {
            return internalFunction.name
        } else {
            return externalFunctionLabels[function]!
        }
        
    }
    
}
