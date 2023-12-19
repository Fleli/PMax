
struct MakefileDefault {
    
    
    static func text(_ targetName: String, _ asLibrary: Bool) -> String {
        
        let buildAsLibrary = asLibrary ? "--as-library " : ""
        let libraryPaths = "_libraries"
        
        return """
        
        ASLIBRARY = \(buildAsLibrary)
        LIBRARYPATHS = "\(libraryPaths)"
        ASMFILE = "out.bba"
        MACHINEFILE = "out.bbx"

        all:
            @clear
            @echo "Compiling (pmax -> assembly)"
            pmax build --target-name $(ASMFILE) $(ASLIBRARY)--lib-paths $(LIBRARYPATHS)
            @echo "Assembling (assembly -> binary)"
            bbasm assemble _targets/$(ASMFILE) _targets/$(MACHINEFILE)
            @echo "Running (binary)"
            bbvm _targets/$(MACHINEFILE)

        """
        
    }
    
    
}
