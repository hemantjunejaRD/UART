`timescale 1ns / 1ns

module BAUD_RATE_GENERATOR(divisor_1,divisor_2,m_clk,reset,tx_clk,rx_clk);
input wire m_clk;
input wire reset;
input wire [7:0] divisor_1;
input wire [7:0] divisor_2;

output reg tx_clk;
output reg rx_clk;

reg [15:0] tx_counter;

wire [15:0] initial_divisor={divisor_2,divisor_1}; 

always @(posedge m_clk)
 begin
  if(reset==1'b1)
   begin
   tx_clk<=1'b0;
   rx_clk<=1'b0;
   tx_counter<=16'h0000;
   end
	else
	  begin
if(tx_counter==initial_divisor)
  begin
   tx_clk<=~tx_clk;
   rx_clk<=~rx_clk;
	tx_counter<=16'h0000;
  end
 else
  begin
   tx_counter<=tx_counter+1'b1;
  end
 end 	
 end
endmodule