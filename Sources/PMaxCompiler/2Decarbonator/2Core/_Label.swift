class Label: Hashable {
    
    private static var counter = 0
    
    private var statements: [DecarbonatedStatement] = []
    
    private let identifier: String
    
    init(_ identifier: String) {
        self.identifier = "_\(identifier)$\(Self.counter)"
        Self.counter += 1
    }
    
    func addStatement(_ statement: DecarbonatedStatement) {
        statements.append(statement)
    }
    
    func addStatements(_ statements: [DecarbonatedStatement]) {
        statements.forEach {
            addStatement($0)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static
    func == (lhs: Label, rhs: Label) -> Bool {
        return lhs === rhs
    }
    
}
