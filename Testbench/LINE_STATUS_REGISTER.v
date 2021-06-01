`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:07 05/28/2021 
// Design Name: 
// Module Name:    LINE_STATUS_REGISTER 
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
module LINE_STATUS_REGISTER(address,data_out_reg,wr_full_tx,FIFO_EN,wr_full_RX,rd_empty_RX,trigger_RX,start_bit_error,parity_bit_error,framing_stop_error,m_clk,reset);
input wr_full_tx;
input FIFO_EN;
input wr_full_RX;
input rd_empty_RX;
input trigger_RX;
input start_bit_error;
input parity_bit_error;
input framing_stop_error;
input m_clk,reset;
input [15:0] address; 
output reg [7:0] data_out_reg;


always @(posedge m_clk)
 begin
 if(reset==1'b1) 
  begin
   data_out_reg<=8'h00;
  end
  else
  if(address==16'h0004)
  begin
   data_out_reg [0]<=FIFO_EN;
	data_out_reg [1]<=wr_full_tx;
	data_out_reg [2]<=rd_empty_RX;;
	data_out_reg [3]<=wr_full_RX;
	data_out_reg [4]<=trigger_RX;
	data_out_reg [5]<=framing_stop_error;
	data_out_reg [6]<=parity_bit_error;
	data_out_reg [7]<=start_bit_error;
  end
end

endmodule
