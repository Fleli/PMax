class AssemblyLowerer {
    
    
    private var tacLabels: [Label]
    
    
    init(_ labels: [Label]) {
        self.tacLabels = labels
    }
    
    
    func lower() -> String {
        
        var output = ""
        
        for label in tacLabels {
            output += label.lowerToBreadboardAssembly()
        }
        
        return output
        
    }
    
    
}
