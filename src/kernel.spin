kernel
                    org $000
'Note: Lock 0 is memory, lock 1 is boot hold, lock 2 is SPI

'Code is kept in 256-long blocks. Each block has one long in a
'table to determine whether it can be used. The table is pro-
'tected by Lock 0. 
'
'Each long contains: owner (1 byte), execution masks (1 byte),
'used (1 byte) and one empty byte.
'

#include <tophalf.spin>

#include <syscalls.spin>

#include <memory.spin>

#include <stdio.spin>

#include <spi.spin>

                    fit 496
