import Foundation

class Preprocessor {
    
    private let fileManager = Foundation.FileManager()
    
    private var currentDirectory: String {
        fileManager.currentDirectoryPath
    }
    
    private var importedLibraries: Set<String> = []
    
    
    
    
    func importLibrary(_ fileName: String) {
        
        let fileName = fileName + ".hmax"
        
        if importedLibraries.contains(fileName) {
            // TODO: Get back to this.
            // Probably doesn't need to submit error: If a library is already imported, just don't reimport it.
            return
        }
        
        print("Working directory: \(currentDirectory)")
        
        let content = searchThroughDirectory(for: fileName, in: currentDirectory)
        
        print("Result of search: {\(content ?? "nil")}")
        
    }
    
    func searchThroughDirectory(for fileName: String, in directory: String) -> String? {
        
        let allObjects: [String]
        
        do {
            allObjects = try fileManager.contentsOfDirectory(atPath: directory)
        } catch {
            return nil
        }
        
        for object in allObjects {
            
            if let result = searchThroughDirectory(for: fileName, in: object) {
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
