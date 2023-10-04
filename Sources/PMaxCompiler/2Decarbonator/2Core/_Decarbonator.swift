class Decarbonator {
    
    
    var structTypes: [String : StructType]
    var functionLabels: [String : FunctionLabel]
    
    var environment: Environment!
    
    init(_ aspartame: Aspartame) {
        
        self.structTypes = aspartame.structTypes
        self.functionLabels = aspartame.functionLabels
        self.environment = nil
        
        self.environment = Environment(self, aspartame)
        
    }
    
    
    func decarbonate() {
        
        for function in functionLabels.values {
            function.decarbonate(self)
        }
        
    }
    
    
    func submitError(_ newError: PMaxError) {
        
    }
    
    
}
