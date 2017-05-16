begin
                    call #clear_block_table
                    call #sys_alloc '0, of course. Also mailboxes.
                    'Prep serial
                    mov x, #SERIAL_RX
                    wrlong x, #128 'rxpin
                    mov x, #SERIAL_TX
                    wrlong x, #132 'txpin
                    mov x, #0
                    wrlong x, #136 'mode
                    mov x, bitticks_tophalf
                    wrlong x, #140 'bitticks
                    neg x, #1
                    wrlong x, #144 'rxbuff
                    neg x, #1
                    wrlong x, #148 'txbuff
                    'Lets release the lock
                    mov x, #1
                    lockclr x
                    mov k, #"#" 'Send character to indicate boot successful
                    call #sys_char
                    
                    call #sys_getch 'Wait for keypress

editor              'Tiny hex editor
                    'call #cls
ed_loop             
                    mov k, #128 'Cursor home
                    call #send_char
                    mov x, ed_addr
                    mov y, #4
ed_display_loop     mov i, x
                    call #debug_hex
                    mov k, #32
                    call #send_char
                    mov k, #"|"
                    call #send_char
                    mov k, #32
                    call #send_char
                    rdlong i, x
                    call #debug_hex
                    mov k, #32
                    call #send_char
                    
                    add x, #4
                    djnz y, #ed_display_loop
                    
                    call #recv_char
                    cmp j, #"p" wz      'Back
              if_z  sub ed_addr, #4
                    cmp j, #";" wz      'Forward
              if_z  add ed_addr, #4 
                    cmp j, #"]" wz      'Backlight ON
              if_z  mov k, #17
              if_z  call #send_char
                    cmp j, #"[" wz      'Backlight OFF
              if_z  mov k, #18
              if_z  call #send_char
                    
                    cmp j, #"=" wz        'Alloc block
              if_z  call #sys_alloc
              
                    cmp j, #"-" wz      'Dealloc block
              if_z  mov i, ed_addr
              if_z  shr i, #2      
              if_z  call #dealloc      

                    cmp j, #"/" wz
              if_z  jmp #dumb_launch            'Dumb launch

                                        
                    mov x, j
                    sub x, #48 wc
              if_c  jmp #test_digit_done
                    mov y, #9
                    cmp y, x wc
              if_c  jmp #test_digit_done
                    rdlong y, ed_addr
                    shl y, #4
                    add y, x
                    wrlong y, ed_addr
                    
                    
test_digit_done     
                    mov x, j
                    sub x, #97 wc
              if_c  jmp #test_alpha_done
                    mov y, #5
                    cmp y, x wc
              if_c  jmp #test_alpha_done
                    add x, #10
                    rdlong y, ed_addr
                    shl y, #4
                    add y, x
                    wrlong y, ed_addr
test_alpha_done

                    jmp #ed_loop

ed_addr             long 0
bitticks_tophalf    long SERIAL_BIT_TICKS

dumb_launch         
                    mov y, #ed_addr
                    shl y, #4
                    or y, #8
                    coginit y
                    jmp #ed_loop

padding             'long  
                    'long         
                    'long 
                    'long 
                    'long
                    long 0,0,0,1,0,1,0,0,0,0,0
                    long 0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0
                    long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    long 0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0
                    long 0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0
                    long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    long 0,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0
                    long 0,0,1,0,0,1,0,1,0,1,0,1,0,1,0,0
                    long 0,0,1,0,0,1,0,1,0,1,0,1,1,0,0,0
                    long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

