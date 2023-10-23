import Foundation

public final class Compiler {
    
    
    public static var allowPrinting = true
    
    
    var fileOptions: [FileOption]
    
    
    public init(_ fileOptions: FileOption ...) {
        self.fileOptions = fileOptions
    }
    
    
    public func compile(_ sourceCode: String) throws {
        try lex(sourceCode)
    }
    
    
    static func print(_ string: String) {
        if Self.allowPrinting {
            Swift.print(string)
        }
    }
    
    
}
