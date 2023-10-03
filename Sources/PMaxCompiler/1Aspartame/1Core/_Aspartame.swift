
public class Aspartame {
    
    private(set) var structs: [Struct] = []
    private(set) var functions: [Function] = []
    
    var structTypes: [String : StructType] = [:]
    var functionLabels: [String : FunctionLabel] = [:]
    
    public init() {
        
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
        
        // Now, we can begin converting most of the grammatical statements to their corresponding Aspartame representation. During this process, we also annotate and check the code with different 
        
    }
    
    
    
    func submitError(_ newError: PMaxError) {
        
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
    
}
