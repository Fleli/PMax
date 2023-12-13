
import Foundation

enum SearchMode {
    
    /// Collect all results matching the given condition
    case collect(predicate: (String) -> Bool)
    
    /// Return immediately upon match
    case one(match: String)
    
}

func deepSearch(_ path: String, _ mode: SearchMode) -> [String] {
    
    var collected: [String] = []
    let allObjects: [String]
    
    do {
        allObjects = try FileManager().contentsOfDirectory(atPath: path)
        print("All objects: \(allObjects)")
    } catch {
        print("Caught (did not find all content @ \(path))")
        return collected
    }
    
    for object in allObjects {
        
        let subresult = deepSearch(path + "/" + object, mode)
        print("Subresult: \(subresult)")
        
        switch mode {
        case .collect(_):
            collected += subresult
        case .one(_):
            return subresult
        }
        
        do {
            
            let found = try String(contentsOfFile: path + "/" + object)
            
            print("Found {\(found)} at path {\(path + "/" + object)}")
            
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
            
            print("Reading from \(path + "/" + object) failed [continue]")
            continue
            
        }
        
    }
    
    return collected
    
}
