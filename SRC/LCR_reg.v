`timescale 1ns / 1ps
//address 0ch
module LCR_reg(counter_id,reset,address,m_clk,data_in,WLS,STB,PEN,EPS,SP,BC);
input wire [6:0] data_in;
input wire reset,m_clk;
input wire [7:0] address;
output reg STB,PEN,EPS,SP,BC;
output reg [1:0] WLS;
output reg [3:0] counter_id;
wire [1:0] WLS1;
wire STB1;
assign WLS1={data_in[1],data_in[0]};

assign STB1=data_in[2];
always @(posedge m_clk)
begin
	if(reset==1'b1)
		begin
					WLS<=2'b00;
					STB<=1'b0;
					PEN<=1'b0;
					EPS<=1'b0;
					SP<=1'b0;
					BC<=1'b0;
		end
   else 
	begin
			if(address==8'b00001100)
				begin
				   WLS<=WLS1;
					STB<=STB1;
					PEN<=data_in[3];
					EPS<=data_in[4];
					SP<=data_in[5];
					BC<=data_in[6];
					if(STB1==1'b0)
					begin
					if(WLS1==2'b00) counter_id<=4'b0110;
					else if(WLS1==2'b01) counter_id<=4'b0111;
					else if(WLS1==2'b10) counter_id<=4'b1101;
					else counter_id<=4'b1100;
					end
	            else
					begin
					if(WLS1==2'b00) counter_id<=4'b0111;
					else if(WLS1==2'b01) counter_id<=4'b1000;
					else if(WLS1==2'b10) counter_id<=4'b1101;
					else counter_id<=4'b1101;
					end
	
				end			
   end

end
endmodule
