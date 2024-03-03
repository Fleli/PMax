
struct MakefileDefault {
    
    
    private static let libPaths = "/opt/cpm/libraries/pmax-packages"
    
    
    static func text(_ targetName: String, _ asLibrary: Bool) -> String {
        
        guard asLibrary else {
            return initializeAsExecutable(targetName)
        }
        
        return """
            
            INCLUDE = "\(Self.libPaths)"
            ASMFILE = "\(targetName)"
            PROFILECOMPILER = #--profile
            EMITINTERMEDIATE = #--emit-offsets --emit-tac --emit-pil
            MAXINSTRUCTIONS = 1000000
            INCLUDECOMMENTS = #--include-comments
            
            all:
            \t@echo "Building ..."
            \tpmax build --target-name $(ASMFILE) --include $(INCLUDE) $(PROFILECOMPILER) $(EMITINTERMEDIATE) $(INCLUDECOMMENTS) --as-library
            
            """
        
    }
    
    
    private static func initializeAsExecutable(_ targetName: String) -> String {
        
        return """
            
            INCLUDE = "\(Self.libPaths)"
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
            \t@echo "Building ..."
            \t@pmax build --target-name $(ASMFILE) --include $(INCLUDE) $(PROFILECOMPILER) $(EMITINTERMEDIATE) $(INCLUDECOMMENTS)
            \t@bbasm assemble _targets/$(ASMFILE).bba _targets/$(MACHINEFILE) $(EMITINDICES) $(PRINTASSEMBLERSTATS)
            \t@echo "Running ..."
            \t@bbvm run _targets/$(MACHINEFILE) $(VIEWEXECUTION) --max-instructions $(MAXINSTRUCTIONS)
            
            """
            
    }
    
    
}
