class StructType: Hashable {
    
    var name: String
    var layout: MemoryLayout?
    
    var sizeInMemory: Int {
        layout?.pointer ?? 1
    }
    
    private let underlyingStructDeclaration: Struct
    
    init(_ structDeclaration: Struct) {
        self.name = structDeclaration.name
        self.underlyingStructDeclaration = structDeclaration
    }
    
    func generateMemoryLayoutIfMissing(_ aspartame: Aspartame, _ dependances: Set<StructType>) {
        
        if dependances.contains(self) {
            aspartame.submitError(.circularStructDefinition(typeName: name))
            return
        }
        
        guard layout == nil else {
            return
        }
        
        let memoryLayout = MemoryLayout()
        let newDependances = dependances.union([self])
        
        for declaration in underlyingStructDeclaration.statements {
            // TODO: Update the grammar so that declarations within structs cannot have default values.
            let fieldName = declaration.name
            
            guard let fieldType = DataType(declaration.type, aspartame) else {
                // TODO: Consider adding a special `.errorType` case to the `DataType` so that _some_ further work can be done (somewhat like Xcode/Swift's <<<error type>>>)
                continue
            }
            
            let fieldSize = fieldType.size(aspartame, newDependances)
            memoryLayout.addMember(fieldName, fieldType, fieldSize)
            
        }
        
    }
    
    static
    func == (lhs: StructType, rhs: StructType) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}
