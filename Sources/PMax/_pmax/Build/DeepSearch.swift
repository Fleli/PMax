
import Foundation


enum SearchMode {
    
    /// Collect all results matching the given condition
    case collect(predicate: (String) -> Bool)
    
    /// Return immediately upon match
    case one(match: String)
    
}

/// Recursively search for files at a given path and in all its children. A search in `.collect` mode will collect content from all files matching a given predicate. Searching in `.one` mode returns immediately when it finds a file with the exact name requested.
func deepSearch(_ path: String, _ mode: SearchMode) -> [String] {
    
    var collected: [String] = []
    let allObjects: [String]
    
    do {
        allObjects = try FileManager().contentsOfDirectory(atPath: path)
    } catch {
        return collected
    }
    
    for object in allObjects {
        
        let subresult = deepSearch(path + "/" + object, mode)
        
        switch mode {
        case .collect(_):
            collected += subresult
        case .one(_) where subresult.count > 0:
            return subresult
        default:
            break
        }
        
        do {
            
            let found = try String(contentsOfFile: path + "/" + object)
            
            switch mode {
            case .collect(let predicate):
                if predicate(object) {
                    collected.append(found)
                }
            case .one(let match):
                if match == object {
                    return [found]
                }
            }
            
        } catch {
            
            continue
            
        }
        
    }
    
    return collected
    
}
