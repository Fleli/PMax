extension TACStatement {
    
    
    func perform_call(_ lhs: Location, _ functionLabel: String, _ returnLabel: String, _ words: Int) -> String {
        
        guard case .framePointer(let offset) = lhs else {
            print("Should never use anything else than a frame pointer in a function call, but found \(lhs).")
            fatalError()
        }
        
        // The calling convention states the following:
        // 1. fp + offset is the first address *currently not in use by this function*. Variables before it has been declared, variables later has not, and so we are NOT in danger of overwriting any data by using the stack space at fp + offset and larger.
        // 2. The words { fp + offset , fp + offset + 1 , ... , fp + offset + words - 1 } will constitute the return value once the subroutine finishes.
        // 3. Therefore, the address fp + offset + words should contain the return address, that is, the location where operation will resume once the function call has finished.
        // 4. And this implies that the address fp + offset + words + 1 should contain the new function's frame pointer (which points to the current function's frame pointer). We must update the stack pointer accordingly.
        
        return
            calculate_stack_pointer_offset(0, offset)                           // find fp + offset
            .addi(0, 0, words + 1, "Find the new frame pointer's address")      // find (fp + offset) + (words + 1). This is the address for the new frame pointer.
            .ld(.stackPointer, 0, "Store the value of the old frame pointer in the new one")
            .addi(.stackPointer, .stackPointer, words + 1, "Increment the stack pointer so it points to the new frame pointer")
            .call(functionLabel, returnLabel, "Call \(functionLabel)")
        
    }
    
    
}
