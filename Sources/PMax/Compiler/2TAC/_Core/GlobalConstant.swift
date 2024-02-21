
enum GlobalConstant: Equatable, Hashable {
    
    
    case stringLiteral(String)
    
    
    static func == (lhs: GlobalConstant, rhs: GlobalConstant) -> Bool {
        
        switch (lhs, rhs) {
        
        case (.stringLiteral(let a), .stringLiteral(let b)):
            return a == b
        }
        
    }
    
    
}
