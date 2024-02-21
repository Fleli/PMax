
import Foundation

enum GlobalConstant: Equatable, Hashable {
    
    
    case stringLiteral(String)
    
    
    func storedWords() -> [Int] {
        
        var words: [Int] = []
        
        switch self {
            
        case .stringLiteral(let string):
            
            let nsString = NSString(string: string)
            
            for i in 0 ..< nsString.length {
                
                // Find the `unichar` (`UInt16`) at position `i`
                let char = nsString.character(at: i)
                
                // Add the char to the list of words
                words.append(Int(char))
                
            }
            
            // Finally, add the terminating null character.
            words.append(0)
            
        }
        
        return words
        
    }
    
    
    static func == (lhs: GlobalConstant, rhs: GlobalConstant) -> Bool {
        
        switch (lhs, rhs) {
        
        case (.stringLiteral(let a), .stringLiteral(let b)):
            return a == b
        }
        
    }
    
    
}
