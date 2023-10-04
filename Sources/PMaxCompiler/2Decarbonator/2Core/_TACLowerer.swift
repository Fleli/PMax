class Decarbonator {
    
    
    var structTypes: [String : StructType]
    var functionLabels: [String : FunctionLabel]
    
    var environment: Environment? = nil
    
    
    init(_ aspartame: Aspartame) {
        
        self.structTypes = aspartame.structTypes
        self.functionLabels = aspartame.functionLabels
        self.environment = Environment(self)
        
    }
    
    
    func decarbonate() {
        
        for function in functionLabels.values {
            function.decarbonate(functionLabels)
        }
        
    }
    
    
}
