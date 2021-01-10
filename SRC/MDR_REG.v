`timescale 1ns / 1ps
//for default 13X sampling and 9600 baud rate

/*osm_sel 
 if 0 13X oversampling bit
 1 for 16X oversampling bit
 */
 
 /*baud rate
 9600 for 0
 19200 for1)
 */

module MDR_REG(reset,address,m_clk,data_in,osm_sel,br);
input [1:0]data_in;
input [7:0] address;
input reset,m_clk;
output osm_sel;
reg osm_sel;
output br;
reg br;
always @(posedge m_clk)
	begin
	if(address==8'h04)
		begin
		if (reset==1'b1)
			begin 
			osm_sel<=1'b0;
			br<=1'b0;
			end
		else
			begin
				if(data_in==2'b00)
					begin
					osm_sel<=1'b0;
					br<=1'b0;
					end
				else if(data_in==2'b01)
					begin
					osm_sel<=1'b0;
					br<=1'b1;
					end
				else if(data_in==2'b10)
					begin
					osm_sel<=1'b1;
					br<=1'b0;
					end
				else 
					begin
					osm_sel<=1'b1;
					br<=1'b1;
					end
			end
		end
	end
endmodule
