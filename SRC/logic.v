`timescale 1ns / 1ps

module logic_tx(address,data_out,WLS,reset,m_clk,data_in);
input wire [15:0] data_in;
input wire [1:0] WLS;
input wire reset;
input wire [7:0 ] address;
input wire m_clk;
output reg [7:0] data_out;

reg bitidx=1'b0;

always @(posedge m_clk)
 begin
	if(address==8'b00000000) begin
	if(WLS==2'b11)
	begin
		if(bitidx==1'b0)
		begin
		data_out <= data_in[7:0];
		bitidx <= bitidx + 1'b1;
		end
		else 
		begin 
		data_out <= data_in[15:8];
		bitidx<=1'b0;
		end
  end
 else
		begin
		data_out <= data_in[7:0];
		bitidx <= bitidx;
		end
end
end
endmodule
