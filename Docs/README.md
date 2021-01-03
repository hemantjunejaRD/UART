# NOTE
The [document](https://github.com/hemantjunejaRD/UART/blob/main/Docs/sprugp1.pdf) above contains UART architecture given by Texas instruments, which consists of programmable buad rate and works on 16X and 13X oversampling mode. 
I have taken it as reference to Design a UART, with fixed baud rates of 9600 and 19200 working on a fixed clock rate of 100Mhz .

### Here we will also discuss about different registers which are used in this architecture in detail.

# <ins>REGISTER</ins>:

**a) FIFO Control Register (FCR):**
The FIFO control register (FCR) is a write-only register. Use the FCR to enable and clear the FIFOs and to select the receiver FIFO trigger level. The FIFOEN bit must be set to 1 before other FCR bits are written to or the FCR bits are not programmed.

|RXFIFTL|TXCLR|RXCLR|FIFOEN|
|-------|-----|-----|------|
|4  -  3|  2  |  1 	|  0   |

1) RXFIFTL:  Receiver FIFO trigger level:  RXFIFTL sets the trigger level for the receiver FIFO. When the trigger level is reached, a receiver data-ready interrupt is generated (if the interrupt request is enabled). When the FIFO drops below the trigger level, the interrupt is cleared. 0 = 1 byte. 1 = 4 bytes. 2 = 8 bytes. 3 = 14 bytes. 
2) TXCLR Transmitter FIFO clear: Write a 1 to TXCLR to clear the bit. 0 = No effect. 1 = Clears transmitter FIFO and resets the transmitter FIFO counter. The shift register is not cleared. 3.5 FIFO Control Register (FCR) 
3) RXCLR Receiver FIFO clear. Write a 1 to RXCLR to clear the bit. 0 = No effect. 1 = Clears receiver FIFO and resets the receiver FIFO counter. The shift register is not cleared. 0 FIFOEN Transmitter and receiver FIFOs mode enable.
4) FIFOEN must be set before other FCR bits are written to or the FCR bits are not programmed. Clearing this bit clears the FIFO counters. 0 =  FIFO OFF. The transmitter and receiver FIFOs are disabled, and the FIFO pointers are cleared. 1 = FIFO mode. The transmitter and receiver FIFOs are enabled.

**b) Mode Definition Register (MDR):**
The Mode Definition Register (MDR) is a write-only register. Use the MDR to selected oversampling mode and to choose a baud rate from 9600 and 19200.

|br|osm_sel|
|--|------|
|1 |  0   |

osm_sel and br,where osm_sel will help to choose from 13X and 16X oversampling mode. setting this bit to 0= 13X oversampling, 1=16X oversampling mode.
br (baud rate), clear this bit to select 9600 baud rate and writing 1 to this bit will choose 19200 baud rate.


