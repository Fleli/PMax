class PILLowerer: CompilerPass {
    
    /// The `local` scope is used to notify the `PILLowerer`'s environment of declarations, and to verify the existence of variables when they are referenced.
    var local: PILScope!
    
    /// Returns a readable description of the whole PIL environment. This includes all functions and structs declared.
    var readableDescription: String {
        functions.reduce("") { $0 + $1.value.fullDescription + "\n" }
        + structs.reduce("") { $0 + $1.value.description + "\n" }
    }
    
    /// The preprocessor object responsible for handling imports.
    private let preprocessor: Preprocessor
    
    /// All structs declared, including those that are imported.
    private(set) var structs: [String : PILStruct] = [:]
    
    /// Maps tuples (lists of types) to the struct representing that tuple.
    private(set) var tuples: [ [PILType] : String ] = [:]
    
    /// All functions declared, including those that are imported.
    private(set) var functions: [String : PILFunction] = [:]
    
    /// A dictionary that maps a struct name to that struct's corresponding memory layout (`MemoryLayout`).
    /// The memory layout describes the internal offsets for each member of the struct.
    private(set) var structLayouts: [String : MemoryLayout] = [:]
    
    /// All declared macros and their corresponding expressions.
    private(set) var macros: [String : Expression] = [:]
    
    /// Initialize a `PILLowerer` object from a number of top-level statements (the whole program) and a preprocessor that handles imports.
    init(_ topLevelStatements: TopLevelStatements, _ preprocessor: Preprocessor, _ compiler: Compiler) {
        
        print("--> init begin")
        
        self.preprocessor = preprocessor
        
        super.init(compiler)
        
        self.local = PILScope(self)
        
        self.prepare(topLevelStatements)
        
        print("--> init done")
        
    }
    
    /// Run PIL lowering.
    /// This will populate the `structs` and `functions` dictionaries. It will also ask the preprocessor to run.
    /// After `lower` is finished, `structs` and `functions` can be used for further lowering to TAC.
    /// If the `noIssues` property on this `TACLowerer` is `false` after running `lower()`, an issue is found, so compilation should be aborted.
    func lower() {
        lowerFunctionBodies()
        findMemoryLayouts()
    }
    
    /// Prepare the `PILLowerer` to lower each function body.
    /// Preparation means _declaring_ all structs, which is essential to do so that functions anytwhere can use a struct type, regardless of whether it was declared before or after the struct.
    /// Preparation also means importing libraries and adding structs & functions declared there to the relevant dictionaries, making them available to the code written by the user.
    /// After imports are resolved and structs are declared, all functions are also declared. This is done afterwards because any function must be able to refer to any type, so they can't be declared until all structs are found.
    private func prepare(_ topLevelStatements: TopLevelStatements) {
        
        print("----> prepare begin")
        
        print("begin structs, macros, imports")
        
        // Go through each top-level statement.
        for syntacticStatement in topLevelStatements {
            
            switch syntacticStatement {
                
            // If the top-level statement is a struct, declare it.
            case .struct(let `struct`):
                
                self.newStruct(`struct`)
                
            // Ignore it (for now) if it is a function.
            case .function(_):
                
                continue
                
            // If the top-level statement is an import, ask the preprocessor to import it.
            case .import(let `import`):
                
                let library = `import`.library
                preprocessor.importLibrary(library, self)
                
            case .macro(let macro):
                
                if macros.keys.contains(macro.name) {
                    submitError(PMaxIssue.invalidMacroRedeclaration(name: macro.name))
                    continue
                }
                
                // TODO: When handled this way, macros may not use each other.
                // Add support for referencing other macros later.
                macros[macro.name] = macro.expression
                
            }
            
        }
        
        print("begin functions")
        
        // Now that every struct is declared, we can start defining functions.
        // We had to wait since a function F might depend on a struct type T declared afterwards in the source code.
        for syntacticStatement in topLevelStatements {
            
            // We ignore everything but functions.
            if case .function(let function) = syntacticStatement {
                
                // Build a new PILFunction object from the syntactical function.
                let pilFunction = PILFunction(function, self)
                self.newFunction(pilFunction)
                
            }
            
        }
        
        print("----> prepare done")
        
    }
    
    /// Lowering function bodies is the second step in lowering to PIL.
    /// This is called after preparations are done (so we have _created_ all `PILFunction` objects, but their bodies haven't been lowered yet).
    /// This function simply asks each function to lower itself to `PIL`. See the `lowerToPIL(_:)` method on `PILFunction` for more on how this is done.
    private func lowerFunctionBodies() {
        
        print("--> lowering function bodies")
        
        for function in functions.values {
            function.lowerToPIL(self)
        }
        
        print("--> done")
        
    }
    
    /// We also need to find the memory layouts of each struct type.
    /// A memory layout contains information on how the struct members are organized within the struct instance.
    private func findMemoryLayouts() {
        
        print("--> Finding memory layouts")
        
        // We go through each struct type
        for `struct` in structs.values {
            
            // We generate a memory layout and pass `self` since structs need access to all other defined structs as well.
            let layout = `struct`.memoryLayout(self)
            structLayouts[`struct`.name] = layout
            
        }
        
        print("--> done")
        
    }
    
    /// Push a new scope on top of the current local scope.
    /// Call this function when entering the body of statements such as `if`, `while`, etc.
    func push() {
        local = PILScope(local)
    }
    
    /// Pop the current local scope.
    /// Call this function when leaving the body of statements such as `if`, `while`, etc.
    func pop() {
        local = local.parent!
    }
    
    /// Return the type of the field `field` in the struct type `type`.
    /// Will submit an error message if `type` is not a struct type, or if the field does not exist. In this case, `PILType.error` is returned.
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
    
    /// Find the return type of a function whose name is `functionName`.
    /// Returns `PILType.error` if no such function exists.
    func functionReturnType(_ functionName: String) -> PILType {
        
        if let localFunctionType = local.getVariable(functionName), case .function(_, let ret) = localFunctionType {
            return ret
        } else if let topLevel = functions[functionName] {
            return topLevel.returnType
        }
        
        return .error
        
    }
    
    /// Take a syntactical `Struct` object, verify that it does not name clash with any existing types.
    func newStruct(_ `struct`: Struct) {
        
        // The struct's name is now considered a new type.
        let type = `struct`.name
        
        // Check that no struct with the same name already exists.
        guard nameIsAvailable(type) else {
            submitError(PMaxIssue.invalidRedeclaratino(struct: type))
            return
        }
        
        // Create a new `PILStruct` object, and add it to the structs dictionary.
        let newStruct = PILStruct(`struct`, self)
        structs[type] = newStruct
        
    }
    
    /// Take a `PILFunction` object and add it to the internal dictionary of functions.
    func newFunction(_ pilFunction: PILFunction) {
        
        let name = pilFunction.name
        
        guard nameIsAvailable(name) else {
            submitError(PMaxIssue.invalidRedeclaration(function: name))
            return
        }
        
        functions[name] = pilFunction
        
    }
    
    /// Returns `true` if a  name is available (i.e. no type/function uses it), and `false` otherwise.
    func nameIsAvailable(_ name: String) -> Bool {
        
        // TODO: Make sure there is consistency between Builtin and this list.
        // This should be solved better than simply ORing different cases. Look into this.
        
        if name == Builtin.void || name == Builtin.native || name == Builtin.char {
            return false
        }
        
        return functions[name] == nil && structs[name] == nil
        
    }
    
    /// Notify the PILLowerer that a tuple was encountered. A new tuple instance is registered if necessary. Otherwise, the PILLowerer just ignores it (so that tuples aren't registered more than once).
    func notfiyTuple(_ structType: Struct) {
        
        let types = structType.statements
            .map { $0.type! }               // All struct fields are compiler-generated, therefore non-`nil`
            .map { PILType($0, self) }      // Convert all fields to PILTypes
        
        if tuples.keys.contains(types) {
            return
        }
        
        newStruct(structType)
        tuples[types] = structType.name
        
    }
    
}
