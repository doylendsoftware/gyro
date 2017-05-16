con

    _clkmode = xtal1 + pll16x
    _xinfreq = 5_000_000
    
    FREQUENCY = 80_000_000
    
    SERIAL_BAUD = 19_200
    SERIAL_BIT_TICKS = FREQUENCY / SERIAL_BAUD
    SERIAL_TX = 0
    SERIAL_RX = 31

	BLOCKS = 32
