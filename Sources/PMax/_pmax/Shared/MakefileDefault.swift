struct MakefileDefault {
    
    static func text(_ targetName: String, _ asLibrary: Bool) -> String {
        
        let options = asLibrary ? "--as-library" : ""
        
        return """
        
        LIBOPTION = \"\(options)\"
        
        all:
        \tpmax build --target-name \(targetName) $(LIBOPTION)
        """
        
    }
    
}
