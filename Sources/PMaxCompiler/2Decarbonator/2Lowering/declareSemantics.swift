extension Scope {
    
    func declareSemantics(_ name: String, _ type: DataType) {
        
        if let alreadyDeclaredType = declarations[name]?.type {
            decarbonator.submitError(.declarationAlreadyExists(name: name, existingType: alreadyDeclaredType.description, attemptedType: type.description))
            return
        }
        
        let declaration = DecarbonatedDeclaration(type, framePointerOffset)
        declarations[name] = declaration
        
        // If the declaration has a type of `.mustBeInferred, we don't know how big it is. However, this _only_ happens when internal variables are generated. An internal variable is always assigned just after declaration.`
        // !!!: Assignments to unknown types (which are then inferred), always advance the frame pointer, because the corresponding declaration _did not_.
        
        print("[\(framePointerOffset): \(name)]")
        
        if case .mustBeInferred = type {
            
        } else {
            framePointerOffset += type.size(aspartame, [])
        }
        
    }
    
}
