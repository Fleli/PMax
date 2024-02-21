class TACLowerer: CompilerPass, CustomStringConvertible {
    
    
    /// The typealias `(PILFunction, Label, Set<Label>)` groups together information about a function, including all its labels, its entry label (used for calling), and its corresponding complete `PILFunction` instance.
    typealias AssociatedFunctionData = (pilFunction: PILFunction, entry: Label, all: Set<Label>, imported: Bool)
    
    // MARK: Internal Properties
    
    /// The current local scope.
    var local: TACScope!
    
    /// The currently active label. The next statement is appended to the current label.
    var activeLabel: Label!
    
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
    
    /// `libraryAssembly` stores all code snippets fetched from imported libraries, concatenated.
    private(set) var libraryAssembly: String = ""
    
    /// This variable contains all declared global constants.
    private(set) var globalPool = GlobalPool()
    
    // MARK: Private Properties
    
    /// Map a struct name to that struct's corresponding `MemoryLayout`.
    private let structLayouts: [String : MemoryLayout]
    
    // MARK: Initializer
    
    init(_ pilLowerer: PILLowerer, _ emitOffsets: Bool, _ compiler: Compiler) {
        
        self.structs = pilLowerer.structs
        self.functions = pilLowerer.functions
        self.structLayouts = pilLowerer.structLayouts
        
        super.init(compiler)
        
        self.local = TACScope(self, emitOffsets)
        
    }
    
    // MARK: Main Lowering Function
    
    func lower(_ compileAsLibrary: Bool) {
        
        for function in functions {
            
            let function = function.value
            
            if case .external(let assembly, let entry) = function.body {
                
                libraryAssembly.append(assembly + "\n")
                newLabel(entry, true, function, true)
                
            } else {
                
                let entry = function.entryLabelName
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
            
            if function.name == "main" && function.returnType == .int && function.parameters.count == 0 {
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
            submitError(PMaxIssue.hasNoValidMain)
            return
        }
        
    }
    
    // MARK: Label Generator
    
    /// Create a new label. If `isFunctionEntry` (if this is the label jumped to when calling a function), its name is the `context`. For other labels used in `if`s etc., an internal counter makes sure no names clash, and just uses the context to give the label an informative name.
    @discardableResult
    func newLabel(_ context: String, _ isFunctionEntry: Bool, _ function: PILFunction, _ imported: Bool = false) -> Label {
        
        let newLabel: Label
        
        if isFunctionEntry {
            
            // The context for an imported library is the full label name, which already includes the leading '@' symbol
            let prefix = imported ? "" : "@"
            
            newLabel = Label(name: prefix + context)
            labels[function.name] = (pilFunction: function, entry: newLabel, all: [], imported)
        } else {
            newLabel = Label(name: "\(autoVariableName("@l"))_\(context)")
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
        let name = "\(autoVariableName("%"))_\(context)"
        return local.declare(type, name)
    }
    
    // MARK: SizeOf
    
    func sizeOf(_ type: PILType) -> Int {
        
        switch type {
            
        case .int, .char, .pointer(_), .function(_, _):
            
            return 1
            
        case .void, .error:
            
            return 0
            
        case .struct(let name):
            
            guard let structLayout = structLayouts[name] else {
                submitError(PMaxIssue.typeDoesNotExist(typeName: type.description))
                return 0
            }
            
            return structLayout.size
            
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
    
    // MARK: Struct Layouts And Member Offsets
    
    /// Return the `MemoryLayout` describing a struct. Assumes that the struct exists (otherwise, `fatalError`).
    func structLayout(_ structName: String) -> MemoryLayout {
        return structLayouts[structName]!
    }
    
    /// Return the internal member offset of `member` in a given struct. Assumes that the struct and member both exist (otherwise, `fatalError`).
    func structMemberOffset(_ structName: String, _ member: String) -> Int {
        return structLayout(structName).fields[member]!.start
    }
    
    // MARK: Global Variable/Constant Handling
    func getStringLiteralAsRValue(_ literal: String) -> RValue {
        return .stringLiteral(globalPoolOffset: globalPool.getStringLiteralOffsetInGlobalPool(literal))
    }
    
}
