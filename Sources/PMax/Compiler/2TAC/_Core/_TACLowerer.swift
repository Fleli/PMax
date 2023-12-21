class TACLowerer: CustomStringConvertible {
    
    typealias Labels = [String : (pilFunction: PILFunction, entry: Label, all: Set<Label>)]
    
    var local: TACScope!
    
    var activeLabel: Label!
    
    let pilLowerer: PILLowerer
    
    var noIssues: Bool {
        return errors.reduce(true, {$0 && $1.allowed})
    }
    
    private var internalCounter = 0
    
    private(set) var structs: [String : PILStruct] = [:]
    
    private(set) var functions: [String : PILFunction] = [:]
    
    /// The `relatedLabels` dictionary maps a function name (`String`) to the set of labels associated with that function, and also explicitly stores the entry label. This is useful when compiling a library.
    private(set) var labels: Labels = [:]
    
    /// `libraryAssembly` stores a list of assembly code snippets fetched from imported libraries. They are `reduce`d to a single `String` and pasted in with the rest of the assembly when compiling executables.
    private(set) var libraryAssembly: [String] = []
    
    private(set) var errors: [PMaxError] = []
    
    init(_ pilLowerer: PILLowerer, _ emitOffsets: Bool) {
        
        self.pilLowerer = pilLowerer
        self.structs = pilLowerer.structs
        self.functions = pilLowerer.functions
        
        self.local = TACScope(self, emitOffsets)
        
    }
    
    
    func lower(_ compileAsLibrary: Bool) {
        
        for function in functions {
            
            let function = function.value
            
            if case .external(let assembly, _) = function.body {
                
                libraryAssembly.append(assembly)
                
            } else {
                
                let entry = function.entryLabelName()
                newLabel(entry, true, function)
                
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
            
            activeLabel = labels[function.name]!.entry
            
            for statement in lowered {
                statement.lowerToTAC(self, function)
            }
            
            pop()
            
        }
        
        guard containsValidMain || compileAsLibrary else {
            submitError(.hasNoValidMain)
            return
        }
        
    }
    
    
    func submitError(_ newError: PMaxIssue) {
        errors.append(newError)
    }
    
    
    /// Create a new label. If `isFunctionEntry` (if this is the label jumped to when calling a function), its name is the `context`. For other labels used in `if`s etc., an internal counter makes sure no names clash, and just uses the context to give the label an informative name.
    @discardableResult
    func newLabel(_ context: String, _ isFunctionEntry: Bool, _ function: PILFunction) -> Label {
        
        let newLabel: Label
        
        if isFunctionEntry {
            newLabel = Label(context)
            labels[function.name] = (pilFunction: function, entry: newLabel, all: [newLabel])
        } else {
            internalCounter += 1
            newLabel = Label("@l\(internalCounter)_\(context)")
        }
        
        labels[function.name]?.all.insert(newLabel)
        return newLabel
        
    }
    
    
    /// Generate (and declare) a new internal variable. It does not collide with any other variable names. It uses a `context` parameter to give a _somewhat_ informative name.
    func newInternalVariable(_ context: String, _ type: PILType) -> Location {
        internalCounter += 1
        let name = "$\(internalCounter)_\(context)"
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
        labels.reduce("", {$0 + "(" + $1.key + ")\n" + $1.value.all.reduce("") { $0 + $1.description + "\n" } + "\n"})
    }
    
    func getFunctionEntryPoint(_ function: String) -> String {
        
        guard let labelGroup = labels[function] else {
            fatalError("Function: \(function). Labels: \(labels)")
        }
        
        return labelGroup.entry.name
        
    }
    
}
