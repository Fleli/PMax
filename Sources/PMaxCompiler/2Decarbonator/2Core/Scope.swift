class Scope {
    
    let aspartame: Aspartame
    let decarbonator: Decarbonator
    
    private var framePointerOffset: Int
    
    private let parent: Scope?
    
    private var declarations: [String : DecarbonatedDeclaration] = [:]
    
    init(_ parent: Scope) {
        self.parent = parent
        self.aspartame = parent.aspartame
        self.decarbonator = parent.decarbonator
        self.framePointerOffset = parent.framePointerOffset
    }
    
    init(_ decarbonator: Decarbonator, _ aspartame: Aspartame) {
        self.parent = nil
        self.framePointerOffset = 0
        self.aspartame = aspartame
        self.decarbonator = decarbonator
    }
    
    func declare(_ name: String, _ type: DataType) {
        
        if let alreadyDeclaredType = declarations[name]?.type {
            decarbonator.submitError(.declarationAlreadyExists(name: name, existingType: alreadyDeclaredType.description, attemptedType: type.description))
            return
        }
        
        let declaration = DecarbonatedDeclaration(type, framePointerOffset)
        declarations[name] = declaration
        
        framePointerOffset += type.size(aspartame, [])
        
    }
    
    func framePointerOffset(_ lhs: String) -> Int? {
        return declarations[lhs]?.framePointerOffset
    }
    
    func type(_ lhs: String) -> DataType? {
        return declarations[lhs]?.type
    }
    
    /// Verify that an assignment is semantically meaningul. Infer the type of `lhs` if it is `.mustBeInferred`. Returns `nil` and produces an error if
    /// (a) the type of `rhs` is `.mustBeInferred` (in which case the assignment to `rhs` must have went wrong earlier on), or
    /// (b) either `lhs` or `rhs` does not exist (is not declared), or
    /// (c) the types of `lhs` and `rhs` do not match.
    func verifyAssignmentSemantics(_ lhs: String, _ rhs: String) -> (lhsOffset: Int, rhsOffset: Int)? {
        
        guard var lhsType = type(lhs) else {
            decarbonator.submitError(.variableDoesNotExist(name: lhs))
            return nil
        }
        
        guard let rhsType = type(rhs) else {
            decarbonator.submitError(.variableDoesNotExist(name: rhs))
            return nil
        }
        
        if case .mustBeInferred = rhsType {
            // We assume that an error was produced earlier if the type of `rhs` is still `.mustBeInferred`
            // TODO: Verify that this assumption holds.
            return nil
        }
        
        if case .mustBeInferred = lhsType {
            inferType(of: lhs, to: rhsType)
            lhsType = rhsType
        }
        
        
        
    }
    
    private func inferType(of lhs: String, to type: DataType) {
        
        guard let lhsOffset = framePointerOffset(lhs) else {
            fatalError("Should be able to find offset of \(lhs) with declarations = \(declarations)")
        }
        
        declarations[lhs] = DecarbonatedDeclaration(type, lhsOffset)
        
    }
    
}

struct DecarbonatedDeclaration {
    
    let type: DataType
    let framePointerOffset: Int
    
    init(_ type: DataType, _ framePointerOffset: Int) {
        self.type = type
        self.framePointerOffset = framePointerOffset
    }
    
}
