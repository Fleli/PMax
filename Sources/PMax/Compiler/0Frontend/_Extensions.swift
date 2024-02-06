
extension Function {
    
    var returnType: `Type` {
        if let type {
            return type
        } else {
            return .basic(Builtin.void)
        }
    }
    
}

extension Types {
    
    func convertToStruct() -> Struct {
        
        var declarations: [Declaration] = []
        
        for (fieldCount, type) in self.enumerated() {
            let declaration = Declaration("f\(fieldCount)", type)
            declarations.append(declaration)
        }
        
        let structType = Struct("tuple<\(self.listForm())>", declarations)
        
        return structType
        
    }
    
}
