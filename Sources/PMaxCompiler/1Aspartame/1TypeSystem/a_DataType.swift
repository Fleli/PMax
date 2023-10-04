indirect enum DataType: CustomStringConvertible, Equatable {
    
    case void
    case __word
    case pointer(DataType)
    case `struct`(StructType)
    
    // TODO: The semantics described here may require not only synthesizing attributes (types), but also inheriting them. Investigate this further ...
    // TODO: The fact that we have a single unknown value here together with several actual available cases, indicates that a single `DataType` enum may not be the way to go. We might have to raise the level of abstraction to separate between known types (void, __word, pointer, struct) and unknown types.
    /// A special, intermediate type whose actual type data must be inferred from context. This is not done during lowering, but rather during name binding.
    case mustBeInferred
    
    var description: String {
        switch self {
        case .void:
            return "void"
        case .__word:
            return "__word"
        case .pointer(let dataType):
            return dataType.description + "*"
        case .struct(let structType):
            return structType.name
        case .mustBeInferred:
            return "[?]"
        }
    }
    
    /// Convert a grammatical `struct` to a semantic `DataType`.
    init?(_ type: `Type`, _ aspartame: Aspartame) {
        
        switch type {
        case .basic(Builtin.void):
            self = .void
        case .basic(Builtin.native):
            self = .__word
        case .basic(let type):
            
            guard let structType = aspartame.structTypes[type] else {
                aspartame.submitError(.typeDoesNotExist(typeName: type))
                return nil
            }
            
            self = .struct(structType)
            
        case .pointer(let pointee, _):
            
            guard let wrapped = DataType(pointee, aspartame) else {
                // If the wrapped type (pointee) does not exist, an error has already been submitted.
                return nil
            }
            
            self = .pointer(wrapped)
            
        }
        
    }
    
    func size(_ aspartame: Aspartame, _ dependances: Set<StructType>) -> Int {
        
        switch self {
        case .void:
            return 0
        case .__word:
            return 1
        case .pointer(_):
            return 1
        case .struct(let structType):
            // We assume that the result we get is meaningful. Otherwise, the `structType` will submit an error itself.
            structType.generateMemoryLayoutIfMissing(aspartame, dependances)
            return structType.sizeInMemory
        case .mustBeInferred:
            fatalError("The size of a type who still is not inferred should never be requested.")
        }
        
    }
    
    static
    func == (lhs: DataType, rhs: DataType) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.void, .void), (.__word, .__word), (.mustBeInferred, .mustBeInferred):
            return true
        case (.pointer(let wrapped1), .pointer(let wrapped2)):
            return wrapped1 == wrapped2
        case (.struct(let t1), .struct(let t2)):
            return t1 == t2
        default:
            return false
        }
        
    }
    
}
