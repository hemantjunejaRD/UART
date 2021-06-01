`timescale 1ns / 1ns

module FIFO_CONTROL_REGISTER(DMA_MODE,RXFIFTL,TXCLR,RXCLR,FIFOEN,m_clk,data_in,reset,address);
input wire m_clk;
input wire [7:0] data_in;
input wire reset;
input wire [15:0] address;
output reg DMA_MODE;
output reg [3:0] RXFIFTL;
output reg TXCLR;
output reg RXCLR;
output reg FIFOEN;

reg [1:0] RXFIFTL_1;
always @(posedge m_clk)
if(reset==1'b1)
 begin 
  RXFIFTL  <= 4'b0000;
  TXCLR    <= 1'b1;
  RXCLR	   <= 1'b1;
  FIFOEN   <= 1'b0;
  DMA_MODE <= 1'b0;
 end
 else begin
 if(address== 16'h0008)
 begin
  FIFOEN   <= data_in[0];
  RXCLR    <= data_in[1];
  TXCLR    <= data_in[2];
  DMA_MODE <= data_in[3];
  RXFIFTL_1  <= {data_in[5],data_in[4]};
 end
 case(RXFIFTL_1)
 2'b00 : RXFIFTL<=4'b0110; 
 2'b01 : RXFIFTL<=4'b1000;
 2'b10 : RXFIFTL<=4'b1010;
 2'b11 : RXFIFTL<=4'b1100;
 endcase
 end
endmodule
