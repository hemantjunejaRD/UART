//Divisior latch to baud rate generator

module DIVISOR_LATCH_MS(divisor_2,m_clk,reset,address,data_in);
input wire [15:0] address;
input wire [7:0] data_in;
input wire m_clk,reset;

output reg [7:0] divisor_2;

always @(posedge m_clk)
 begin
  if(reset==1'b1)
   begin
    divisor_2<=16'h00;
   end
	else 
	 begin
    if(address==16'h0030)
     begin
     divisor_2<=data_in[7:0];
     end
    end
  end
endmodule
