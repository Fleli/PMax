
extension Function {
    
    var returnType: `Type` {
        if let type {
            return type
        } else {
            return .basic(Builtin.void)
        }
    }
    
}
