
struct MakefileDefault {
    
    
    static func text(_ targetName: String, _ asLibrary: Bool) -> String {
        
        let buildAsLibrary = asLibrary ? "--as-library " : ""
        let libraryPaths = "_libraries"
        
        return """
        
        LIBRARYPATHS = \"\(libraryPaths)\"
        
        all:
        \tpmax build --target-name \(targetName) \(buildAsLibrary)--lib-paths $(LIBRARYPATHS)
        """
        
    }
    
    
}
