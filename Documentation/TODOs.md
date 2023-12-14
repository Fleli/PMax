#  TODOs

## Investigate incorrect assembly file output

During work on the `Runtime` library for memory management (`alloc`, `realloc`, `dealloc`), a (probably incorrect) assembly result was produced.
The TAC statement seems fine, so the issue probably lies in TAC -> ASM conversion. 

### Input
```
struct MemoryBlock {
    int minAddress;
    int maxAddress;
}

void overwrite_memory_block(void* address, int min, int max) {
    
    MemoryBlock block;
    
    assign block.minAddress = min;
    assign block.maxAddress = max;
    
    assign (as MemoryBlock) (*address) = block;
    
}
```

### Output
```
void overwrite_memory_block(void* address, int min, int max) {
    Label fn_overwrite_memory_block;
    assign asm = "
fn_overwrite_memory_block:

 ; [1]  [fp + 4] = [fp + 2]
    ldio r0, r7, 2                                   ; r0 = [fp + 2]
    stio r7, 4, r0                                   ; [fp + 4] = r0

 ; [1]  [fp + 5] = [fp + 3]
    ldio r0, r7, 3                                   ; r0 = [fp + 3]
    stio r7, 5, r0                                   ; [fp + 5] = r0

 ; [2]  [raw @ fp + 1] = [fp + 4]
    ldio r0, r7, 4                                   ; r0 = [fp + 4]
    ldio r1, r7, 1                                   ; r1 = [fp + 1]
    st r1, r0                                        ; [r1] = r0
    ldio r0, r7, 4                                   ; r0 = [fp + 4]
    ldio r1, r7, 1                                   ; r1 = [fp + 1]
    st r1, r0                                        ; [r1] = r0

 ; [0]  ret [void]
    addi r0, r7, -1                                  ; r0 = fp + -1
    ldfr r0, r0                                      ; Fetch [fp - 1]
    j r0                                             ; Jump to the address stored in r0.

";
}
```

### Issue
The TAC command `[2]  [raw @ fp + 1] = [fp + 4]` is itself correct. However, the produced assembly code seems to simply store the memory block's first word twice, instead of storing both words. Clearly, this will produce incorrect results.
