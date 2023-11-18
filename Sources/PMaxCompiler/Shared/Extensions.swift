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

extension `Type`: Equatable {
    
    public static func == (lhs: `Type`, rhs: `Type`) -> Bool {
        switch (lhs, rhs) {
        case (.basic(let a), .basic(let b)):
            return a == b
        case (.pointer(let p1, _), .pointer(let p2, _)):
            return p1 == p2
        default:
            return false
        }
    }
    
}
