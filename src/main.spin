#include <constants.spin>

pub main
    'serdrv := @ser_entry
    lockset(1)
    coginit(1,@ser_entry,128)
    'waitcnt(cnt+clkfreq*5)
    coginit(0,@kernel,0)

dat

#include <kernel.spin>

#include <serial.spin>
