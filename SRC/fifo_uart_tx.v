module fifo_uart_tx (counter_id,start,data_out, wr_full, rd_empty,FIFO_EN,data_in,address,rd_clk, wr_clk, reset,clr);
input wire [7:0] data_in;
input wire rd_clk, wr_clk,clr;
input wire reset;
input wire [7:0] address; 
input wire [3:0] counter_id;
input wire FIFO_EN;
output reg  [7:0] data_out;
output  reg wr_full;
output reg start;
output  reg rd_empty;

reg [4:0] rd_pointer=5'b00000;
reg [4:0] wr_pointer=5'b00000; 
reg [4:0] rd_sync_1, rd_sync_2;
reg [4:0] wr_sync_1, wr_sync_2;
wire [4:0] rd_pointer_g,wr_pointer_g;
reg [3:0] bitidx = 4'b0000;
reg [7:0] mem [15 : 0];
wire wr_full_1;
wire rd_empty1;

wire [4:0] rd_pointer_sync;
wire [4:0] wr_pointer_sync;

//--write pointer synchronizer controled by read clock--//
always @(posedge rd_clk) begin
	wr_sync_1 <= wr_pointer_g;
	wr_sync_2 <= wr_sync_1;
end

//--read pointer synchronizer controled by write clock--//
always @(posedge wr_clk) begin
	rd_sync_1 <= rd_pointer_g;
	rd_sync_2 <= rd_sync_1;
end


//--binary code to gray code--//
assign wr_pointer_g = wr_pointer ^ (wr_pointer >> 1);
assign rd_pointer_g = rd_pointer ^ (rd_pointer >> 1);



//--gray code to binary code--//
assign wr_pointer_sync = wr_sync_2 ^ (wr_sync_2 >> 1) ^ 
						(wr_sync_2 >> 2) ^ (wr_sync_2 >> 3)^ (wr_sync_2 >> 4);

assign rd_pointer_sync = rd_sync_2 ^ (rd_sync_2 >> 1) ^ 
						(rd_sync_2 >> 2) ^ (rd_sync_2 >> 3)^ (rd_sync_2 >> 4);


//--write logic--//
always @(posedge wr_clk or posedge reset) begin
	if (reset || clr ) begin
		// reset
		wr_pointer <= 0;
	end
	else if (wr_full == 1'b0) begin
			if(address==8'b00000000 && FIFO_EN==1'b1)
		   begin 
			wr_pointer <= wr_pointer + 1;
			mem[wr_pointer[3 : 0]] <= data_in;
			
			end
	else wr_pointer <= wr_pointer;
	end
end

//--read logic--//

always @(posedge rd_clk or posedge reset)
 begin
	if (reset || clr) 
	begin
    	rd_pointer <= 0;
	end
	if (rd_empty1==1'b0) 
	begin
		if(bitidx==counter_id)
		begin
			rd_pointer <= rd_pointer + 1;
			bitidx <= 4'b0000;
		end
	   else 
		begin
		rd_pointer <= rd_pointer;
		bitidx <= bitidx + 1'b1;
		end
	end
end

//--Combinational logic--//
//--Binary pointer--//
assign wr_full_1  = ((wr_pointer[3 : 0] == rd_pointer_sync[3 : 0]) && 
				(wr_pointer[4] != rd_pointer_sync[4] ));
assign rd_empty1 = ((wr_pointer_sync - rd_pointer) == 0) ? 1'b1 : 1'b0;

always @(posedge rd_clk)
begin
if(reset || clr) 
begin
data_out <= 8'h00;
start <= 1'b0;
end
else if(rd_empty1==1'b0)
begin 
data_out <= mem[rd_pointer[4 : 0]];
start <= 1'b1;
end
else begin 
start <= 1'b0;
data_out <=8'hXX;
end
end

always @(posedge wr_clk)
begin
if(address==8'h00)
wr_full <= wr_full_1;
end

always @(posedge rd_clk)
begin
rd_empty <= rd_empty1;
end

endmodule