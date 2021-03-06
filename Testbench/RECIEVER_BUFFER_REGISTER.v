`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:42 05/28/2021 
// Design Name: 
// Module Name:    RECIEVER_BUFFER_REGISTER 
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

module RECIEVER_BUFFER_REGISTER(m_clk,reset,data_in,address,data_out_reg);
input wire m_clk;
input wire reset;
input wire [7:0] data_in;
input wire[15:0] address;

output reg [7:0] data_out_reg;

always @(posedge m_clk)
 begin
 if(reset==1'b1) 
  begin
   data_out_reg<=8'h00;
  end
  else
  if(address==16'h0000)
  begin
   data_out_reg<=data_in;
  end
end
endmodule

