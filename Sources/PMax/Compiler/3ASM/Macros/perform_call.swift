extension TACStatement {
    
    
    func perform_call(_ lhs: Location, _ functionLabel: String, _ returnLabel: String, _ words: Int) -> String {
        
        /// The `returnValueOffset` is the frame pointer offset (relative to the calling function) of the return value.
        /// Relative to the new function (where this will be negative), this is seen as a place to put the return value.
        /// Relative to the calling function, this number is positive (and the value of `returnValueOffset` is), and represents the variable being assigned the result of the call.
        guard case .framePointer(let returnValueOffset) = lhs else {
            fatalError("SHOULD BE UNREACHABLE. Expected frame pointer as LHS, but found \(lhs.description).")
        }
        
        // ----- CALLING CONVENTION -----
        //  1.  The variable in the old function is stored at a certain offset, `returnValueOffset`, from the old frame pointer.
        //      When the new function returns, it puts the return value exactly in the location where the old function stores its variable.
        //      In other words, for a call `x = y()`, the location of `x` and return value of `y()` align exactly in memory.
        //      These take up the words { fp + returnValueOffset , ... , fp + returnValueOffset + words - 1 } in memory.
        //  2.  In the memory location after the returned value, `returnValueOffset + words`, we find the return address.
        //      When the function returns, it jumps to this address.
        //      NOTE: This address is not known right now, since the compiler deals with labels. The assembler will resolve these addresses.
        //  3.  Then comes the new relative zero, which is located at `fp + returnValueOffset + words + 1`.
        //      The value here points to the old such value (together, all these relative zeros make up a linked list).
        
        /// The `code` variable is a string that accumulates all call-related code.
        var code = String()
        
        // ----- CALCULATE AND STORE THE NEW FRAME POINTER -----
        let newFPRelativeToPreviousFP = returnValueOffset + words + 1
        code = code.addi(0, .stackPointer, newFPRelativeToPreviousFP, "Compute address of new relative zero (fp + \(returnValueOffset) + \(words) + 1)")
        code = code.st(0, .stackPointer, "Store the current frame pointer at the new relative zero")
        code = code.mv(.stackPointer, 0, "Upate the frame pointer register to use the new relative zero")
        
        // ----- INSERT THE CALL PSEUDOINSTRUCTION -----
        code = code.call(functionLabel, returnLabel, "Call, entry \(functionLabel), return \(returnLabel)")
        
        // ----- RETURN THE ACCUMULATED ASSEMBLY CODE -----
        return code
        
    }
    
    
}
