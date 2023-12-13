protocol PMaxError: CustomStringConvertible {
    
    var allowed: Bool { get }
    
}

extension [PMaxError] {
    
    var readableFormat: String {
        reduce("", {$0 + $1.description + "\n"})
    }
    
}
