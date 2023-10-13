class PILStruct: CustomStringConvertible {
    
    let name: String
    var fields: [String : PILType] = [:]
    
    init(_ underlyingStructDeclaration: Struct, _ lowerer: PILLowerer) {
        
        self.name = underlyingStructDeclaration.name
        
        for stmt in underlyingStructDeclaration.statements {
            
            let fieldName = stmt.name
            let type = PILType(stmt.type, lowerer)
            
            if stmt.value != nil {
                lowerer.submitError(<#T##newError: PMaxError##PMaxError#>)
                // TODO: Consider changing the grammar, or producing an issue.
            }
            
            guard fields[fieldName] == nil else {
                lowerer.submitError(.redeclarationOfField(structName: name, field: fieldName))
                // Continue the loop so we still get all other fields.
                continue
            }
            
            fields[fieldName] = type
            
        }
        
    }
    
    var description: String {
        return "struct \(name) {\n" + fields.map { "\($0.key) \($0.value)" } . reduce("", {$0 + "\t" + $1 + ";\n"}) + "}"
    }
    
}
