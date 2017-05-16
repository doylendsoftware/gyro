send_char           rdlong j, #148 'USES J
                    shr j, #31 wz
               if_z jmp #send_char
                    wrlong k, #148
                    
send_char_ret       ret

'#144
recv_char           'Uses j and k. Character is in j.  
                    rdlong j, #144
                    neg k, #1
                    xor k, j
                    tjz k, #recv_char
                    neg k, #1
                    wrlong k, #144
                   
recv_char_ret       ret

debug_hex           'Assumes item is in i; uses j, k,and z
                    mov z, #8
debug_hex_loop      
                    mov k,i
                    shr k, #28
                    and k, #$f
                    cmp k, #10 wc
              if_nc add k, #55
              if_c  add k, #48
                    shl i, #4
                    call #send_char
                    djnz z, #debug_hex_loop
                    
debug_hex_ret       ret

