
public class Aspartame {
    
    private var internalVariableCounter = 0
    
    private(set) var structs: [Struct] = []
    private(set) var functions: [Function] = []
    
    var structTypes: [String : StructType] = [:]
    var functionLabels: [String : FunctionLabel] = [:]
    
    // TODO: Introduce an `operators` array or dictionary that stores all available operators.
    // This will be used whenever an operator occurs in a grammatical `Expression`.
    // private(set) var operators: [Operator : ]
    
    public init() {
        print("init Aspartame")
    }
    
    
    public func convert(_ program: TopLevelStatements) {
        
        // Fill `self.structs` and `self.functions` so that they are accessible in extensions.
        prepare(program)
        
        // Generate the `StructType` objects and store them in `structTypes`. This step just initializes and stores the `StructType` objects. Each `StructType` also store their underlying (grammatical) `Struct` object.
        generateTopLevelStructTypes()
        
        // Generate memory layouts by converting the (grammatical) paramater and return types of each field in the struct to well-defined `DataType` instances. It then uses that type information to determine the memory layout and size of a struct instance. This step will also find any cyclic (directly self-referential) structs.
        completeTopLevelStructTypes()
        
        // Generate `FunctionLabel` objects from each of the grammatical `Function`s. During initialization of a `FunctionLabel`, the function's return type and parameter types are checked (it is verified that those types exist). Also, errors are submitted if function names collide.
        generateFunctionLabels()
        
        // Now, we can begin lowering most of the grammatical statements to their corresponding Aspartame representation. During this process, we type check expressions and generate their equivalent three-address code-like (Aspartame form) representation, introducing temprorary variables along the way. Since some of these may be pruned away later by optimizations, we do _not_ bind names or calculate frame pointer offsets at this stage.
        lowerToAspartame()
        
        for function in functionLabels.values {
            print("Function \(function.name)")
            function.loweredBody.forEach {
                $0._print(indent: 1)
            }
        }
        
    }
    
    
    internal func submitError(_ newError: PMaxError) {
        
    }
    
    private func prepare(_ program: TopLevelStatements) {
        for statement in program {
            switch statement {
            case .struct(let `struct`):
                structs.append(`struct`)
            case .function(let function):
                functions.append(function)
            }
        }
    }
    
    /// Create a new internal variable that is guaranteed to not have a name conflict with any other variable in the program. To enforce this assumption, all internally generated variables come directly from the shared `Aspartame` object. All internally generated variables have the initial type `.mustBeInferred`.
    internal func newInternalVariable() -> (statement: AspartameStatement, name: String) {
        
        // We don't know the type of internally generated variables yet. It will have to be up to the inferencer and type checker to verify that inferring a type makes sense.
        let type = DataType.mustBeInferred
        
        // $(n) is not an available name for the programmer, so we're certain to aviod naming conflicts.
        let name = "$(\(internalVariableCounter))"
        internalVariableCounter += 1
        
        let statement = AspartameStatement.declaration(name: name, type: type)
        
        return (statement, name)
        
    }
    
}
