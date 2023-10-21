extension TACStatement {
    
    
    func lowerToBreadboardAssembly() -> String {
        
        
        switch self {
        case .jump(let label):
            return "\tj \(label)\n"
        default:
            return ""
        }
        
    }
    
    
}
