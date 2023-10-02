
public class Aspartame {
    
    private(set) var structs: [Struct] = []
    private(set) var functions: [Function] = []
    
    var structTypes: [String : StructType] = [:]
    
    
    public init() {
        
    }
    
    
    
    public func convert(_ program: TopLevelStatements) {
        
        prepare(program)
        
        generateTopLevelStructTypes()
        completeTopLevelStructTypes()
        
        
        
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
