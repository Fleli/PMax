class TACLowerer: ErrorReceiver {
    
    var local: PILScope!
    
    
    private(set) var errors: [PMaxError] = []
    
    private var labels: Set<Label> = []
    private var labelCount = 0
    
    
    init() {
        self.local = PILScope(self)
    }
    
    
    func submitError(_ newError: PMaxError) {
        errors.append(newError)
    }
    
    
    func newLabel(_ context: String) -> Label {
        
        labelCount += 1
        
        let newLabel = Label("$label\(labels):\(context)")
        labels.insert(newLabel)
        
        return newLabel
        
    }
    
    
}
