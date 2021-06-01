
`define IDLE        3'b010
`define START_BIT   3'b011 // transmitter only
`define DATA_BITS   3'b100
`define PARITY_BIT  3'b101
`define STOP_BIT    3'b110
`define RESET       3'b000
module TRANSMITTER_TIMING_AND_SHIFT_REGISTER (
input wire m_clk,
input wire reset,
input wire PEN,
input wire EPS,
input wire BC,
input wire STB,
input wire SP,
input wire [1:0] WLS,
input wire start, // start of transaction
input wire [7:0] data_in, // data to transmitfdone
output reg out,   // tx
output reg done,  // end on transaction
output reg busy   // transaction is in process
);

reg [2:0] state=`RESET;
reg [7:0] data   = 8'b0;	 // to store a copy of input data
reg [2:0] bitIdx;
reg [2:0] bitIdx_1;	 // for 8-bit data

always @(posedge m_clk) 
begin
if(WLS==2'b00) 
  bitIdx_1<=3'b100;
else if(WLS==2'b01)  
  bitIdx_1<=3'b101;
else if(WLS==2'b10) 
  bitIdx_1<=3'b110;
else if(WLS==2'b11) 
  bitIdx_1<=3'b111;
end
			
always @(posedge m_clk)
begin
  if(BC==1'b1)
  begin
  out <= 1'b0;
  state <= `IDLE;
  end
else
case (state)
default     : state   <= `IDLE;

`IDLE       : begin 
              out     <= 1'b1; // drive line high for idle
              done    <= 1'b0;
              busy    <= 1'b0;
              bitIdx  <= 3'b0;
              data    <= 8'b0;
              if (start) 	
               begin
                data    <= data_in; // save a copy of input data
                state   <= `START_BIT;
	       end
	      end

`START_BIT  : begin
              state   <= `DATA_BITS;
              out     <= 1'b0; // send start bit (low)
	           busy    <= 1'b1;
              end
						
`DATA_BITS  : begin // Wait 8 clock cycles for data bits to be sent
              out     <= data[bitIdx];
              if (bitIdx==bitIdx_1) 
               begin
                bitIdx  <= 3'b0;
                state   <= `PARITY_BIT;
               end
	      else begin
                bitIdx  <= bitIdx + 1'b1;
	             state   <= `DATA_BITS;
               end
              end			
`PARITY_BIT : begin
	      if(PEN==1'b0)
	       begin
		 busy    <= 1'b1;
		 state   <= `STOP_BIT;
	       end 
	     else begin
		 if(SP==1'b0) 
		 begin
		  if(EPS==1'b0)
		   begin
		    if(^data)
		     begin
		      out<=1'b0;
		      state   <= `STOP_BIT;
		     end
		    else
		     begin
		      out    <= 1'b1;
		      state   <= `STOP_BIT;
		     end
	           end 
		else begin
		if(^data)
		 begin
		  out<=1'b1;
		  state   <= `STOP_BIT;
		 end
		else begin
		  out<=1'b0;
		  state   <= `STOP_BIT;
		 end
                end
	       end
	      else begin 
	       if(EPS==1'b0)
		begin
	         out <= 1'b1;
		 state  <= `STOP_BIT;
		end
	      else 
		begin
		 out <= 1'b0;
		 state   <= `STOP_BIT;
	        end
	      end
	     end
	    end
				
`STOP_BIT   : begin // Send out Stop bit (high)
               data    <= 8'b0;
               if(STB==1'b0)
		begin
		 out	  <= 1'b0;
		 done    <= 1'b1;
		 state   <= `IDLE;
		end 
	       else begin
		 out<=2'b01;
		 done    <= 1'b1;
		 state   <= `IDLE;
	        end
              end
		
        endcase
end
endmodule