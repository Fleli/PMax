class AssemblyLowerer {
    
    
    private var tacLabels: [Label]
    
    private var output: String = ""
    
    
    init(_ labels: [Label]) {
        self.tacLabels = labels
    }
    
    
    func lower() {
        
        for label in tacLabels {
            output += label.lowerToBreadboardAssembly()
        }
        
        print(output)
        
    }
    
    
}
