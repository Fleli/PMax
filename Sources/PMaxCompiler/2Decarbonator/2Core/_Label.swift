class Label: Hashable, CustomStringConvertible {
    
    private static var counter = 0
    
    private var statements: [DecarbonatedStatement] = []
    
    private let identifier: String
    
    var description: String {
        return "\(identifier):" + statements.reduce("", {$0 + "\n\t" + $1.description})
    }
    
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
