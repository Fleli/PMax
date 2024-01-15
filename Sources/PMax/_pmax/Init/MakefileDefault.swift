
struct MakefileDefault {
    
    
    private static let libPaths = "_libraries"
    
    
    static func text(_ targetName: String, _ asLibrary: Bool) -> String {
        
        guard asLibrary else {
            return initializeAsExecutable(targetName)
        }
        
        return """
            
            LIBRARYPATHS = "\(Self.libPaths)"
            ASMFILE = "\(targetName)"
            PROFILECOMPILER = #--profile
            EMITINTERMEDIATE = #--emit-offsets --emit-tac --emit-pil
            MAXINSTRUCTIONS = 1000000
            INCLUDECOMMENTS = #--include-comments
            
            all:
            \t@clear
            \tpmax build --target-name $(ASMFILE) --lib-paths $(LIBRARYPATHS) $(PROFILECOMPILER) $(EMITINTERMEDIATE) $(INCLUDECOMMENTS) --as-library
            
            """
        
    }
    
    
    private static func initializeAsExecutable(_ targetName: String) -> String {
        
        return """
            
            LIBRARYPATHS = "\(Self.libPaths)"
            ASMFILE = "\(targetName)"
            MACHINEFILE = "\(targetName).bbx"
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
            \tbbasm assemble _targets/$(ASMFILE).bba _targets/$(MACHINEFILE) $(EMITINDICES) $(PRINTASSEMBLERSTATS)
            \tbbvm run _targets/$(MACHINEFILE) $(VIEWEXECUTION) --max-instructions $(MAXINSTRUCTIONS)
            
            """
            
    }
    
    
}
