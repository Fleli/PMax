class PILLowerer {
    
    /// The `local` scope is used to notify the `PILLowerer`'s environment of declarations, and to verify the existence of variables when they are referenced.
    var local: PILScope!
    
    let id = Int.random(in: 1 ... 10000000)
    
    var noIssues: Bool {
        return errors.reduce(true, {$0 && $1.allowed})
    }
    
    var readableDescription: String {
        functions.reduce("") { $0 + $1.value.fullDescription + "\n" }
        + structs.reduce("") { $0 + $1.value.description + "\n" }
    }
    
    var newAnonymousVariable: String {
        self.anonymousVariableCounter += 1
        return "%\(anonymousVariableCounter)"
    }
    
    private var anonymousVariableCounter = 0
    
    private let preprocessor: Preprocessor
    private let topLevelStatements: TopLevelStatements
    
    private(set) var errors: [PMaxError] = []
    
    private(set) var structs: [String : PILStruct] = [:]
    private(set) var functions: [String : PILFunction] = [:]
    
    private(set) var structLayouts: [String : MemoryLayout] = [:]
    
    
    init(_ topLevelStatements: TopLevelStatements, _ preprocessor: Preprocessor) {
        
        self.topLevelStatements = topLevelStatements
        self.preprocessor = preprocessor
        self.local = PILScope(self)
        
    }
    
    
    func lower() {
        
        prepare()
        lowerFunctionBodies()
        findMemoryLayouts()
        
        for error in errors {
            Compiler.print(error.description)
        }
        
    }
    
    private func prepare() {
        
        // First go through structs and imports
        
        for syntacticStatement in topLevelStatements {
            
            switch syntacticStatement {
            case .struct(let `struct`):
                
                self.newStruct(`struct`)
                
            case .function(_):
                
                continue
                
            case .import(let `import`):
                
                let library = `import`.library
                preprocessor.importLibrary(library, self)
                
            }
            
        }
        
        // ... then lower functions to PIL
        
        for syntacticStatement in topLevelStatements {
            
            if case .function(let function) = syntacticStatement {
                
                let pilFunction = PILFunction(function, self)
                self.newFunction(pilFunction)
                
            }
            
        }
        
    }
    
    private func lowerFunctionBodies() {
        
        for function in functions.values {
            function.lowerToPIL(self)
        }
        
    }
    
    private func findMemoryLayouts() {
        for `struct` in structs.values {
            let layout = `struct`.memoryLayout(self)
            structLayouts[`struct`.name] = layout
            
            guard let layout else {
                continue
            }
            
            Compiler.print("Memory layout for '\(`struct`.name)': \(layout)")
            
        }
    }
    
    func push() {
        local = PILScope(local)
    }
    
    func pop() {
        local = local.parent!
    }
    
    /// Verify that `type` is a struct and that it has a field named `field`. Return the type if it exists. The `fieldType` method will submit any necessary error messages.
    func fieldType(_ field: String, of type: PILType) -> PILType {
        
        if case .error = type {
            return .error
        }
        
        guard case .struct(let name) = type else {
            submitError(PMaxIssue.cannotFindMemberOfNonStructType(member: field, type: type))
            return .error
        }
        
        guard let pilStruct = structs[name] else {
            submitError(PMaxIssue.typeDoesNotExist(typeName: name))
            return .error
        }
        
        guard let type = pilStruct.fields[field] else {
            submitError(PMaxIssue.fieldDoesNotExist(structName: name, field: field))
            return .error
        }
        
        return type
        
    }
    
    func functionType(_ functionName: String) -> PILType {
        return functions[functionName]?.type ?? .error
    }
    
    func submitError(_ newError: PMaxError) {
        errors.append(newError)
    }
    
    
    /// Take a syntactical `Struct` object and add it to the internal dictionary of structs.
    func newStruct(_ `struct`: Struct) {
        
        let type = `struct`.name
        
        guard structs[type] == nil else {
            submitError(PMaxIssue.invalidRedeclaratino(struct: type))
            return
        }
        
        let newStruct = PILStruct(`struct`, self)
        structs[type] = newStruct
        
    }
    
    
    /// Take a `PILFunction` object and add it to the internal dictionary of functions.
    func newFunction(_ pilFunction: PILFunction) {
        
        let name = pilFunction.name
        
        guard functions[name] == nil else {
            submitError(PMaxIssue.invalidRedeclaration(function: name))
            return
        }
        
        functions[name] = pilFunction
        
    }
    
}
