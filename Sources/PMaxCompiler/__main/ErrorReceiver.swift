protocol ErrorReceiver: AnyObject {
    
    func submitError(_ newError: PMaxError)
    
}
