//specification:
//counter 9bits;
//we have considered clock frequency to be 100Mhz;

//For 13X oversampling,
//baud rate is 9600
//divisor 802
//error -0.0895%

// for 13X oversampling
//baud rate is 19200
//divisor =400
//error percentage= 0.16

//For 16X oversampling,
//baud rate is 9600
//divisor 650
//error = 0.160%

//Baud rate is  19200
//divisor 326
//divisor 163=10100011
//error percentage when we take divisor 326 will be -0.146


`timescale 1ns / 1ps
module baud_generator(m_clk,reset,osm_sel,br,tx_clk,rx_clk);
input wire osm_sel;
input wire br;
input wire m_clk;
input wire reset;
output tx_clk,rx_clk;
reg tx_clk;
reg rx_clk;

reg [8:0] tx_counter=9'b000000000;
reg [8:0] rx_counter=9'b000000000;

initial
begin 
tx_clk=1'b0;
rx_clk=1'b0;
end

always @(posedge m_clk)
begin
if(osm_sel==1'b0)
	begin
		if(br==1'b0) // 13X sampling
				begin
					if(rx_counter==9'b110010001)
						begin 
						rx_clk<=~rx_clk;
						rx_counter<=9'b000000000;
						end
					else
						begin
						rx_counter<=rx_counter + 1'b1;
						end

					//For TX
					if(tx_counter==9'b110010001)
						begin 
						tx_clk<=~tx_clk;
						tx_counter<=9'b000000000;
						end
					else
						begin
						tx_counter<=tx_counter + 1'b1;
						end
				end
		else
				begin
					if(rx_counter==9'b011001000)
						begin 
						rx_clk<=~rx_clk;
						rx_counter<=9'b000000000;
						end
					else
						begin
						rx_counter<=rx_counter + 1'b1;
						end

					//For TX
					if(tx_counter==9'b011001000)
						begin 
						tx_clk<=~tx_clk;
						tx_counter<=9'b000000000;
						end
					else
						begin
						tx_counter<=tx_counter + 1'b1;
						end
				end
			end
	else
		begin
				if(br==1'b0) // 16X sampling
				begin
					if(rx_counter==9'b101000101)
						begin 
						rx_clk<=~rx_clk;
						rx_counter<=9'b000000000;
						end
					else
						begin
						rx_counter<=rx_counter + 1'b1;
						end

					//For TX
					if(tx_counter==9'b101000101)
						begin 
						tx_clk<=~tx_clk;
						tx_counter<=9'b000000000;
						end
					else
						begin
						tx_counter<=tx_counter + 1'b1;
						end
				end
			else
				begin
					if(rx_counter==9'b010100011)
						begin 
						rx_clk<=~rx_clk;
						rx_counter<=9'b000000000;
						end
					else
						begin
						rx_counter<=rx_counter + 1'b1;
						end

					//For TX
					if(tx_counter==9'b010100011)
						begin 
						tx_clk<=~tx_clk;
						tx_counter<=9'b000000000;
						end
					else
						begin
						tx_counter<=tx_counter + 1'b1;
						end

				end
		end
	end

endmodule

