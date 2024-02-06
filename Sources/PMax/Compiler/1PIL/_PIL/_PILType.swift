
indirect enum PILType: CustomStringConvertible, Hashable {
    
    case int
    case void
    case `struct`(name: String)
    case pointer(pointee: PILType)
    case function(input: PILType, output: PILType)
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
        case .function(let input, let output):
            return input.description + " -> " + output.description
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
            
        case .basic(let id) where lowerer.structs[id] != nil:
            
            self = .struct(name: id)
            
        case .basic(let undefined):
            
            lowerer.submitError(PMaxIssue.typeDoesNotExist(typeName: undefined))
            self = .error
            
        case .pointer(let wrapped, _):
            
            let pilWrapped = PILType(wrapped, lowerer)
            self = .pointer(pointee: pilWrapped)
            
        case .tuple(_, let types, _):
            
            switch types.count {
                
            case 0:
                
                self = .void
                
            case 1:
                
                self = PILType(types[0], lowerer)
                
            default:
                
                let structType = types.convertToStruct()
                lowerer.notfiyTuple(structType)
                self = .struct(name: structType.name)
                
            }
            
        case .function(let input, _, let output):
            
            let inType = PILType(input, lowerer)
            let outType = PILType(output, lowerer)
            
            if (inType == .error) || (outType == .error) {
                self = .error
                return
            }
            
            self = .function(input: inType, output: outType)
            
        }
        
    }
    
    /// Checks if `self` is assignable to `other`. Consider the attempt to assign an `int` to a `T*`. Since the lanugage spec specifies that implicit `int`-to-pointer conversions are allowed, this would return `true`.
    func assignable(to other: PILType) -> Bool {
        
        switch (self, other) {
            
        case (.function(let inA, let outA), .function(let inB, let outB)):
            return (inA.assignable(to: inB)) && (outA.assignable(to: outB))
        case (.void, .void):
            return true
        case (_, .void), (.void, _):                // void cannot be assigned to anything and is not assignable itself
            return false
        case (_, .error), (.error, _):              // we allow errors to be assigned since an error message is already submitted if we have an error
            return true
        case (.int, .int):                          // int can be assigned to int
            return true
        case (.pointer(.void), .pointer(let p)) where p != .void:   // Allow implicit void* -> T* conversions.
            return true
        case (.pointer(_), .int):                   // implicit pointer-to-int conversion is allowed in assignments
            return false
        case (.int, .pointer(_)):                   // implicit int-to-pointer conversion is always allowed
            return true
        case (.pointer(let a), .pointer(let b)):    // a pointer can only be assigned to an identical pointer
            return a == b
        case (.`struct`(let a), .`struct`(let b)):  // a struct can only be assigned to an identical struct
            return a == b
        default:                                    // other combinations are not allowed
            return false                            // TODO: Verify that no combinations are missed.
            
        }
        
    }
    
}
