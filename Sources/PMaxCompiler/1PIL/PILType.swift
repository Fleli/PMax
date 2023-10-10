indirect enum PILType: CustomStringConvertible {
    
    case word
    case void
    case error
    case `struct`(name: String)
    case pointer(pointee: PILType)
    
    var description: String {
        switch self {
        case .word:
            return Builtin.native
        case .void:
            return Builtin.void
        case .error:
            return "<<error>>"
        case .struct(let name):
            return name
        case .pointer(let pointee):
            return pointee.description + "*"
        }
    }
    
    init(_ underlyingType: `Type`, _ lowerer: PILLowerer) {
        
        switch underlyingType {
        case .basic(Builtin.native):
            self = .word
        case .basic(Builtin.void):
            self = .void
        case .basic(let id):
            self = .struct(name: id)
        case .pointer(let wrapped, _):
            let pilWrapped = PILType(wrapped, lowerer)
            self = .pointer(pointee: pilWrapped)
        }
        
    }
    
}
