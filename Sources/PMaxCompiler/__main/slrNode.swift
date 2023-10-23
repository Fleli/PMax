extension SLRNode {
    
    func treeDescription(_ indent: Int) -> String {
        
        let prefix = String(repeating: "| ", count: indent)
        
        var description = prefix + self.type + "\n"
        
        for child in self.children {
            description += child.treeDescription(indent + 1)
        }
        
        return description
        
    }
    
}
