class Label {
    
    private(set) var statements: [AspartameStatement] = []
    
    func includeCode(_ newStatements: [AspartameStatement]) {
        statements += newStatements
    }
    
}
