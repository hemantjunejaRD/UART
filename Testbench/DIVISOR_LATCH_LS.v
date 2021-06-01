//Divisior latch to baud rate generator

module DIVISOR_LATCH_LS(output reg [7:0] divisor_1,input wire m_clk,input wire reset,input wire [15:0] address,input wire [7:0] data_in);

always @(posedge m_clk)
 begin
  if(reset==1'b1)
   begin
    divisor_1<=8'h00;
   end
else begin
  if(address==16'h002c)
   begin
   divisor_1<=data_in[7:0];
   end
 end
 end
endmodule