protocol PMaxError: CustomStringConvertible {
    
}

extension [PMaxError] {
    
    var readableFormat: String {
        reduce("", {$0 + $1.description + "\n"})
    }
    
}
