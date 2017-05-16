spi_long            'Channel in i, data in k, bits in j.
                    'Uses x,y,z. Destroys all.
                    mov x, #2
                    lockset x wc
              if_c  jmp #spi_long
                    'We have the lock. For safety's sake, toggle CLR.
                    mov x, #1
                    shl x, #8
                    or outa, x 'Toggle CLR        'FIXME: Set up dira
                    nop
                    xor outa, x 'Turn it off
                    mov x, #1
                    shl x, #25
                    tjz i, #spi_select_done
spi_select_loop     
                    or outa, x
                    nop
                    xor outa, x
                    djnz i, #spi_select_loop
spi_select_done

