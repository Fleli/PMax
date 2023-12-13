struct TargetDefaults {
    
    static func name(_ suppliedTargetName: String?, _ library: Bool) -> String {
        return suppliedTargetName ?? ( library ? "NewLibrary.hmax" : "out.bba" )
    }
    
}
