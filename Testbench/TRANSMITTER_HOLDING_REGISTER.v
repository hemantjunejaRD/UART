module TRANSMITTER_HOLDING_REGISTER(m_clk,reset,data_in,address,data_out_reg);
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