extension PILType {
    
    
    static func inferBinaryOperatorType(_ t1: PILType, _ t2: PILType) -> PILType? {
        
        switch (t1, t2) {
            
        case (.error, _), (_, .error):
            return .error
        case (.int, .int):
            return .int
        case (.pointer(let p), .int):
            return .pointer(pointee: p)
        case (.int, .pointer(let p)):
            return .pointer(pointee: p)
        case (.pointer(let p1), .pointer(let p2)) where p1 == p2:
            return .int
        default:
            return nil
            
        }
        
    }
    
    
    static func inferUnaryOperatorType(_ t: PILType) -> PILType? {
        
        switch t {
        case .int, .pointer(_):
            return t
        case .void, .error, .struct(_):
            return .error
        }
        
    }
    
    
}
