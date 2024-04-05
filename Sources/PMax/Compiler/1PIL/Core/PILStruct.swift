class PILStruct: CustomStringConvertible {
    
    let name: String
    var fields: [String : PILType] = [:]
    var sortedFields: [String] = []
    
    init(_ underlyingStructDeclaration: Struct, _ lowerer: PILLowerer) {
        
        self.name = underlyingStructDeclaration.name
        
        for stmt in underlyingStructDeclaration.statements {
            
            guard let stmtType = stmt.type else {
                lowerer.submitError(PMaxIssue.structMembersCannotHaveDefaultValues(structName: name, field: stmt.name))
                continue
            }
            
            let fieldName = stmt.name
            sortedFields.append(fieldName)
            let type = PILType(stmtType, lowerer)
            
            if stmt.value != nil {
                lowerer.submitError(PMaxIssue.structMembersCannotHaveDefaultValues(structName: self.name, field: fieldName))
            }
            
            guard fields[fieldName] == nil else {
                lowerer.submitError(PMaxIssue.redeclarationOfField(structName: name, field: fieldName))
                // Continue the loop so we still get all other fields.
                continue
            }
            
            fields[fieldName] = type
            
        }
        
    }
    
    var description: String {
        
        var string = "struct \(name) {\n"
        
        for field in sortedFields {
            
            let type = fields[field]!
            let declaration = "\t\(type.description) \(field);\n"
            string += declaration
            
        }
        
        string += "}"
        
        return string
        
    }
    
}
