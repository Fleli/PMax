class TACLowerer: CustomStringConvertible {
    
    
    /// The typealias `(PILFunction, Label, Set<Label>)` groups together information about a function, including all its labels, its entry label (used for calling), and its corresponding complete `PILFunction` instance.
    typealias AssociatedFunctionData = (pilFunction: PILFunction, entry: Label, all: Set<Label>)
    
    
    // MARK: Internal Properties
    
    /// The current local scope.
    var local: TACScope!
    
    /// The currently active label. The next statement is appended to the current label.
    var activeLabel: Label!
    
    /// Returns `true` if no issues were found, i.e. if it is safe to generate code. Warnings are allowed, so this returns `true` even if warnings were generated.
    var noIssues: Bool {
        return errors.reduce(true, {$0 && $1.allowed})
    }
    
    /// Build a description of the `TACLowerer` instance.
    /// This description contains includes all functions and their related labels and entry points.
    var description: String {
        labels.reduce("", {$0 + "(" + $1.key + ")\n" + $1.value.all.reduce("") { $0 + $1.description + "\n" } + "\n"})
    }
    
    // MARK: Private(set) Properties
    
    /// All structs declared in the program and imported libraries.
    private(set) var structs: [String : PILStruct] = [:]
    
    /// All functions declared in the program and imported libraries.
    private(set) var functions: [String : PILFunction] = [:]
    
    /// Maps a function name (`String`) to data associated with that function. This data includes the corresponding `PILFunction` instance, function entry label, and a set of _all_ labels that are part of the function.. This is useful when compiling a library.
    private(set) var labels: [String : AssociatedFunctionData] = [:]
    
    /// `libraryAssembly` stores a list of assembly code snippets fetched from imported libraries. They are `reduce`d to a single `String` and pasted in with the rest of the assembly when compiling executables.
    private(set) var libraryAssembly: [String] = []
    
    /// The ordered list of errors (issues and warnings) found by the `TACLowerer` instance.
    private(set) var errors: [PMaxError] = []
    
    // MARK: Private Properties
    
    // TODO: Replace the PILLowerer, which as a whole isn't really interesting, with just the struct layouts dictionary. However, first verify that we really don't need more than that.
    /// The `PILLowerer` instance that supplied this `TACLowerer` with data.
    /// The `PILLowerer` is used to find struct layouts.
    private let pilLowerer: PILLowerer
    
    /// Map a struct name to that struct's corresponding `MemoryLayout`.
    private let structLayouts: [String : MemoryLayout]
    
    /// Counts the number of labels generated. Used to make sure all label names are unique.
    private var labelCounter = 0
    
    /// Counts the number of internal variables generated. Used to make sure all internal variable names are unique.
    private var variableCounter = 0
    
    // MARK: Initializer
    
    init(_ pilLowerer: PILLowerer, _ emitOffsets: Bool) {
        
        self.pilLowerer = pilLowerer
        self.structs = pilLowerer.structs
        self.functions = pilLowerer.functions
        self.structLayouts = pilLowerer.structLayouts
        
        self.local = TACScope(self, emitOffsets)
        
    }
    
    // MARK: Main Lowering Function
    
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
    
    // MARK: Error Submission
    
    func submitError(_ newError: PMaxIssue) {
        errors.append(newError)
    }
    
    // MARK: Label Generator
    
    /// Create a new label. If `isFunctionEntry` (if this is the label jumped to when calling a function), its name is the `context`. For other labels used in `if`s etc., an internal counter makes sure no names clash, and just uses the context to give the label an informative name.
    @discardableResult
    func newLabel(_ context: String, _ isFunctionEntry: Bool, _ function: PILFunction) -> Label {
        
        let newLabel: Label
        
        if isFunctionEntry {
            newLabel = Label(context)
            labels[function.name] = (pilFunction: function, entry: newLabel, all: [newLabel])
        } else {
            labelCounter += 1
            newLabel = Label("@l\(labelCounter)_\(context)")
        }
        
        labels[function.name]?.all.insert(newLabel)
        return newLabel
        
    }
    
    // MARK: Internal Variable Generator
    
    // TODO: Consider implementing a function for generating stack-allocated internal variables
    // Essentially calling this and wrapping it in a stack-rvalue/lvalue since this is a common pattern
    // This might clear up the code on the calling side.
    
    /// Generate (and declare) a new internal variable.
    /// This variable is guaranteed not to collide with any other variable names.
    /// It uses a `context` parameter to give a _somewhat_ informative name.
    /// Returns the frame pointer offset of the newly declared variable.
    func newInternalVariable(_ context: String, _ type: PILType) -> Int {
        variableCounter += 1
        let name = "$\(variableCounter)_\(context)"
        return local.declare(type, name)
    }
    
    // MARK: SizeOf
    
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
    
    // MARK: Scope Push & Pop
    
    func push() {
        local = TACScope(local)
    }
    
    func pop() {
        local = local.parent!
    }
    
    // MARK: Function Entry Points
    
    func getFunctionEntryPoint(_ function: String) -> String {
        
        guard let labelGroup = labels[function] else {
            fatalError("Function: \(function). Labels: \(labels)")
        }
        
        return labelGroup.entry.name
        
    }
    
    // MARK: Struct Layouts
    
    /// Return the `MemoryLayout` describing a struct. Assumes that the struct exists (otherwise, `fatalError`).
    func structLayout(_ structName: String) -> MemoryLayout {
        return structLayouts[structName]!
    }
    
}
