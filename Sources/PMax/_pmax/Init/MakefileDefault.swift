
struct MakefileDefault {
    
    
    static func text(_ targetName: String, _ asLibrary: Bool) -> String {
        
        guard asLibrary else {
            return initializeAsExecutable(targetName)
        }
        
        return """
        
        all:
            @echo "Initialization as library is not supported yet."
        
        """
        
    }
    
    
    private static func initializeAsExecutable(_ targetName: String) -> String {
        
        let libraryPaths = "_libraries"
        
        return """
        
        LIBRARYPATHS = "\(libraryPaths)"
        ASMFILE = "\(targetName)"
        MACHINEFILE = "\(targetName)"
        PROFILECOMPILER = #--profile
        VIEWEXECUTION = #--view-short
        PRINTASSEMBLERSTATS = #--print-stats
        EMITINTERMEDIATE = #--emit-offsets --emit-tac --emit-pil
        EMITINDICES = #--emit-indices
        MAXINSTRUCTIONS = 1000000
        INCLUDECOMMENTS = #--include-comments
        
        all:
        \t@clear
        \tpmax build --target-name $(ASMFILE) --lib-paths $(LIBRARYPATHS) $(PROFILECOMPILER) $(EMITINTERMEDIATE) $(INCLUDECOMMENTS)
        \tbbasm assemble _targets/$(ASMFILE) _targets/$(MACHINEFILE) $(EMITINDICES)
        \tbbvm run _targets/$(MACHINEFILE) $(VIEWEXECUTION) --max-instructions $(MAXINSTRUCTIONS)
        
        """
        
    }
    
    
}
