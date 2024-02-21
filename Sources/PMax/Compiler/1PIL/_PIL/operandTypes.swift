extension PILType {
    
    
    static func inferBinaryOperatorType(_ t1: PILType, _ t2: PILType) -> PILType? {
        
        switch (t1, t2) {
            
        // any error will propagate
        case (.error, _), (_, .error):
            return .error
        
        // int X int is the most used one
        case (.int, .int):
            return .int
            
        // char X int arithmetic is allowed (e.g. for offsetting from a certain number)
        case (.int, .char), (.char, .int):
            return .char
            
        // pointer X int is allowed, since offsetting pointers is useful
        case (.pointer(let p), .int):
            return .pointer(pointee: p)
            
        // pointer X int is allowed, since offsetting pointers is useful
        case (.int, .pointer(let p)):
            return .pointer(pointee: p)
            
        // pointer X pointer arithmetic makes sense in special cases, like ptr == NULL
        case (.pointer(let p1), .pointer(let p2)) where p1 == p2:
            return .int
        
        // no other combination of types is allowed
        default:
            return nil
            
        }
        
    }
    
    
    static func inferUnaryOperatorType(_ t: PILType) -> PILType? {
        
        switch t {
        case .int, .pointer(_):
            return t
        case .void, .char, .error, .struct(_), .function(_, _):
            return .error
        }
        
    }
    
    
}
