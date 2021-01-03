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

#                             ARCHITECTURE PROVIDED BY TI
<p align="center">
<img width="560" height="550" src="https://user-images.githubusercontent.com/31381446/103456531-2aa85f80-4d1d-11eb-8bd6-aa35630a284e.png">
</p>
 #                              MODIFIED ARCHITECTURE
<p align="center">
<img width="560" height="550" src="https://user-images.githubusercontent.com/31381446/103456643-2597e000-4d1e-11eb-962a-99fddfd63232.png">
</p>
## Now, Let's look inside the Architecture of UART and try to implement it;
**Some of the specifications of this uart are as follows**; <br />
**1**. It can send a 16 bit data, by breaking it into two 8-8 bits.To select this configuration we need to program configure WLS bit in LCR register. <br />
**2**. It sends low bit at the start of the transmission of data. <br />
**3**. It can send a odd parity or even parity bit, or ca stick parity depending on selection in LCR register. <br />
**4**. We can send 1 or 2 stop bits, depending upon selection in LCR register. <br />

### <ins>Data bus inside UART</ins>
<p align="center">
<img width="500" height="90" src="https://user-images.githubusercontent.com/31381446/103474449-e58e3700-4dc9-11eb-947e-2b97d79c4176.png">
</p>
### <ins>Address of different register</ins>
<p align="center">
  <img width="560" height="300" src="https://user-images.githubusercontent.com/31381446/103474461-08b8e680-4dca-11eb-9a9a-adf6a49681b7.png">
</p>
