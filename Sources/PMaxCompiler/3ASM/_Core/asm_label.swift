extension Label {
    
    
    func lowerToBreadboardAssembly() -> String {
        
        var assembly = "\n\(self.name):\n"
        
        for statement in self.statements {
            assembly += statement.lowerToBreadboardAssembly()
        }
        
        return assembly
        
    }
    
    
}
