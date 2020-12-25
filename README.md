# UART
UART stands for universal asynchronous reciever and transmitter, which is able to take parallel input data bits and send them serially. Similarly, Serial data is recieved from the UART and send in parallel fashion to the data bus.

# OBJECTIVE
To design and implement UART, which is able to take 32 bits of data. Each 32 bit data frame consists of 8 bit address, 8 bit of control signals, and 8/16 bit of data bits. On final completion of design and verifications we will generate its GDS file using an open source tool "OpenLANE".

# SPECIFICATIONS
1.  Clock frequency to the UART module is of 100 Mhz.
2.  It can work for two baud rates that are 9600 and 19200.
3.  It has two oversampling mode; 16X oversampling and 13X oversampling.
4.  Transmitter holding register(THR) and Receiver buffer register (RBR) are replaced with TX FIFO and Reciever FIFO.
5.  Choice of two different types of STOP bits can be added. 
6.  Different types of parity bits like odd and even parity bit can be added.
