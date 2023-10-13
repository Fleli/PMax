indirect enum PILType: CustomStringConvertible, Hashable {
    
    case int
    case void
    case `struct`(name: String)
    case pointer(pointee: PILType)
    case error
    
    var description: String {
        switch self {
        case .int:
            return Builtin.native
        case .void:
            return Builtin.void
        case .struct(let name):
            return name
        case .pointer(let pointee):
            return pointee.description + "*"
        case .error:
            return "<error>"
        }
    }
    
    init(_ underlyingType: `Type`, _ lowerer: PILLowerer) {
        
        switch underlyingType {
        case .basic(Builtin.native):
            self = .int
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
