sys_halt        jmp #sys_halt
zero            long 0

i               long 0
j               long 0
k               long 0
x               long 0
y               long 0
z               long 0

sys_alloc       call #alloc
sys_alloc_ret   ret
sys_dealloc     call #dealloc
sys_dealloc_ret ret
sys_contig      call #alloc_contig
sys_contig_ret  ret
sys_char        call #send_char
sys_char_ret    ret
sys_hex         call #debug_hex
sys_hex_ret     ret
sys_getch       call #recv_char
sys_getch_ret   ret

