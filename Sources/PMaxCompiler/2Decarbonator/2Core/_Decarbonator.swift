class Decarbonator {
    
    
    var structTypes: [String : StructType]
    var functionLabels: [String : FunctionLabel]
    
    var environment: Environment!
    
    var errors: [PMaxError] = []
    
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
        
        print("\nErrors:")
        for error in errors {
            print("\t\(error.description)")
        }
        
    }
    
    
    func submitError(_ newError: PMaxError) {
        errors.append(newError)
    }
    
    
}
