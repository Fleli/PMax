extension Scope {
    
    func declareSemantics(_ name: String, _ type: DataType) {
        
        if let alreadyDeclaredType = declarations[name]?.type {
            decarbonator.submitError(.declarationAlreadyExists(name: name, existingType: alreadyDeclaredType.description, attemptedType: type.description))
            return
        }
        
        let declaration = DecarbonatedDeclaration(type, framePointerOffset)
        declarations[name] = declaration
        
        framePointerOffset += type.size(aspartame, [])
        
    }
    
}
