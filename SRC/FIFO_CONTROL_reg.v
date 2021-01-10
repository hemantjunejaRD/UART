`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:26:34 12/26/2020 
// Design Name: 
// Module Name:    FIFO_CONTROL_reg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FIFO_CONTROL_reg(RXFIFTL,TXCLR,RXCLR,FIFOEN,m_clk,data_in,reset,address);
input wire m_clk;
input wire [4:0] data_in;
input wire reset;
input wire [7:0] address;
output reg [1:0] RXFIFTL;
output reg TXCLR;
output reg RXCLR;
output reg FIFOEN;

always @(posedge m_clk)
begin
 if(reset==1'b1)
	begin 
		RXFIFTL <= 2'b00;
		TXCLR   <= 1'b0;
		RXCLR	  <= 1'b0;
		FIFOEN  <= 1'b0;
	end
 else begin
	if(address== 8'b00001000)
		 begin
			FIFOEN  <= data_in[0];
			RXCLR   <= data_in[1];
			TXCLR	  <= data_in[2];
			RXFIFTL <= {data_in[4],data_in[3]};
		 end
		end
 end
endmodule
