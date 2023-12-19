
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
        ASMFILE = "out.bba"
        MACHINEFILE = "out.bbx"
        PROFILECOMPILER = --profile
        VIEWEXECUTION =
        EMITINTERMEDIATE = #--emit-offsets --emit-tac --emit-pil
        EMITINDICES = #--emit-indices
        MAXINSTRUCTIONS = 10000000
        
        all:
            @clear
            @echo "Compiling (pmax -> assembly)"
            @pmax build --target-name $(ASMFILE) --lib-paths $(LIBRARYPATHS) $(PROFILECOMPILER) $(EMITINTERMEDIATE)
            @echo "Assembling (assembly -> binary)"
            @bbasm assemble _targets/$(ASMFILE) _targets/$(MACHINEFILE) $(EMITINDICES) --print-stats
            @echo "Running (binary)"
            @bbvm run _targets/$(MACHINEFILE) $(VIEWEXECUTION) --max-instructions $(MAXINSTRUCTIONS)
        
        """
        
    }
    
    
}
