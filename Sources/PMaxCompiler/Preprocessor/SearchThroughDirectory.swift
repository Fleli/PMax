import Foundation

extension Preprocessor {
    
    func searchThroughDirectory(for fileName: String, in directory: String) -> String? {
        
        let allObjects: [String]
        
        do {
            allObjects = try fileManager.contentsOfDirectory(atPath: directory)
        } catch {
            return nil
        }
        
        for object in allObjects {
            
            if let result = searchThroughDirectory(for: fileName, in: directory + "/" + object) {
                return result
            }
            
            do {
                
                return try String(contentsOfFile: directory + "/" + fileName)
                
            } catch {
                
                continue
                
            }
            
        }
        
        return nil
        
    }
    
}
