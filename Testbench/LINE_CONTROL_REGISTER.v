
`timescale 1ns / 1ns
//address 0ch

module LINE_CONTROL_REGISTER(osm_sel,bitIdx_1,reset,address,m_clk,data_in,WLS,STB,PEN,EPS,SP,BC);
input wire [7:0] data_in;
input wire [15:0] address;
input wire reset,m_clk;
output reg STB,PEN,EPS,SP,BC;
output reg [1:0] WLS;
output reg [3:0] bitIdx_1;
output reg osm_sel;
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
	 osm_sel<=1'b0;
   end
else begin
  if(address==16'h000c)
   begin
    WLS<=WLS1;
    STB<=STB1;
    PEN<=data_in[3];
    EPS<=data_in[4];
    SP<=data_in[5];
    BC<=data_in[6];
	 osm_sel<=data_in[7];
   end
end
end
//new added
always @(posedge m_clk) 
begin
case (PEN)
1'b0: begin
		if(WLS==2'b00) 
		bitIdx_1<=3'b100;
		else if(WLS==2'b01)  
		bitIdx_1<=3'b101;
		else if(WLS==2'b10) 
		bitIdx_1<=3'b110;
		else if(WLS==2'b11) 
		bitIdx_1<=3'b111;
		end
1'b1: begin
      if(STB==1'b0)
		begin
		if(WLS==2'b00) 
		bitIdx_1<=4'b0111;
		else if(WLS==2'b01)  
		bitIdx_1<=4'b1000;
		else if(WLS==2'b10) 
		bitIdx_1<=4'b1001;
		else if(WLS==2'b11) 
		bitIdx_1<=4'b1010;
		end
		else 
		begin
		if(WLS==2'b00) 
		bitIdx_1<=4'b1000;
		else if(WLS==2'b01)  
		bitIdx_1<=4'b1001;
		else if(WLS==2'b10) 
		bitIdx_1<=4'b1010;
		else if(WLS==2'b11) 
		bitIdx_1<=4'b1011;
		end
		end
endcase
end
endmodule