/// Use a `ConditionResult` whenever a statement needs to do branches/jumps. The statement can decide where the program path continues, and it tells the calling statement this by notifying it of the new path.
struct ConditionResult {
    
    let newPath: Label
    let lowered: [AspartameStatement]
    
    init(_ newPath: Label, _ lowered: [AspartameStatement]) {
        self.newPath = newPath
        self.lowered = lowered
    }
    
}
