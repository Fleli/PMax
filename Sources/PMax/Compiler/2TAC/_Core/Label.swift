class Label: Hashable, CustomStringConvertible {
    
    let name: String
    
    var description: String {
        "\(name):\n" + statements.reduce("", {$0 + "\t" + $1.description + "\n"})
    }
    
    private(set) var statements: [TACStatement]
    
    init(_ name: String) {
        self.name = name
        self.statements = []
    }
    
    func newStatement(_ new: TACStatement) {
        statements.append(new)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Label, rhs: Label) -> Bool {
        return lhs.name == rhs.name
    }
    
}
