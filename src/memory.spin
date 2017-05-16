
clear_block_table   mov i, #32 
                    mov j, #0
clear_loop          wrlong zero, j
                    add j, #4
                    djnz i,#clear_loop
clear_block_table_ret ret

alloc_contig        'Allocate a contiguous set of blocks, i is number of blocks
                    'NOTES: j counts contig
                    'Uses first-avail strategy
                    'Not efficient
contig_lock_loop     lockset zero wc 'Try to set the lock
            if_c    jmp #contig_lock_loop
                    'We have the lock
                    mov k, #0 'Counts address index
                    mov j, #0 'Counts contig sf
finder_loop         rdlong x, k wz 'Get from table to x
            if_z    add j,#1 'Got something? Add
            if_nz   mov j, #0 'Not empty? Reset
                    'Increment k (does not check for overflow TODO)
                    add k, #4

                    'If we have i, success
                    cmp i, j wz 
            if_z    jmp #contig_good
                    jmp #finder_loop
contig_good         'All good!
                    shr k, #2 'Make K the index instead of address.
                    sub k, i  'Find first block
                    mov z, k   'Stow it in Z
                    'Mark (terrible hack, must fix TODO)
                    neg y, #1
                    shl k, #2
contig_alloc_loop   wrlong y,k
                    add k,#4
                    djnz i, #contig_alloc_loop
                    lockclr zero
alloc_contig_ret    ret

alloc               'Allocate a block
alloc_lock_loop     lockset zero wc 'Try to set the lock
            if_c    jmp #alloc_lock_loop
                    'We have the lock
                    'mov k, #"R"
                    'call #send_char
                    mov j, #0
                    mov x, #blocks
alloc_find_loop     
                    rdlong k, j 'Allocated? (TODO)
                    
                    
                    tjz k, #finish_good 'If not allocated, go fix!
                    
                    add j, #4
                    djnz x, #alloc_find_loop
                    'If we got here, no free block
                    'Stow -1 in j
                    neg j, #1
                    'Address is in j
alloc_finish        lockclr zero
                    jmp #alloc_ret
finish_good         neg k, #1
                    wrlong k, j
                    lockclr zero
                    shr j, #2 'Move j to be index not addr
alloc_ret   ret


dealloc             'Deallocate a block. Block is in i.
dealloc_lock_loop     lockset zero wc 'Try to set the lock
            if_c    jmp #dealloc_lock_loop
                    'We have the lock
                    shl i, #2 'Multiply by 4 to get long
                    'We don't even bother checking it right now TODO
                    wrlong zero,i
                    
                    lockclr zero
                    
dealloc_ret         ret


