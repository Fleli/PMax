
public class Aspartame {
    
    
    var structTypes: [String : StructType] = [:]
    
    
    public init() {
        
    }
    
    
    
    public func convert(_ program: TopLevelStatements) {
        generateTopLevelStructTypes(program)
    }
    
    
    
    
    
}
