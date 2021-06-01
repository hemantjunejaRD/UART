`define RESET 3'b000
`define  IDLE  3'b001
`define  DATA_BITS 3'b010
`define  PARITY_BITS 3'b011
`define  STOP_BIT 3'b100

module RECIEVER_TIMING_AND_SHIFT_REGISTER (
	 input  wire       EPS,
	 input  wire       PEN,
	 input  wire       SP,
    input  wire [1:0] WLS,
	 input  wire       clk,  // baud rate
    input  wire       reset,
    input  wire       in,   // rx
    input wire osm_sel,
    output reg  [7:0] out_rx,  // received data
    output reg        done_rx, // end on transaction
    output reg        busy_rx, // transaction is in process
    output reg        start_bit_error,
	 output reg        parity_bit_error,
    output reg        framing_stop_error);


// states of state machine

reg [2:0] state;
    
reg [2:0] bitIdx = 3'b0; // for 8-bit data
reg [1:0] inputSw = 2'b0; // shift reg for input signal state
reg [3:0] clockCount = 4'b0; // count clocks for 16x oversample
reg [7:0] receivedData = 8'b0; // temporary storage for input data

wire parity_check= ^receivedData;;


always @(posedge clk) begin

inputSw = { inputSw[0], in };
        if (reset) begin
            state <= `RESET;
        end

case (state)
`RESET: begin
        out_rx <= 8'b0;
		  start_bit_error <= 1'b0;
	     parity_bit_error <= 1'b0;
        framing_stop_error <= 1'b0;
        done_rx <= 1'b0;
        busy_rx <= 1'b0;
        bitIdx <= 3'b0;
        clockCount <= 4'b0;
        receivedData <= 8'b0;
        if (reset) 
         begin
          state <= `IDLE;
         end
       end

`IDLE: begin
       if (osm_sel==1'b0) begin
	if(clockCount==4'b1100) begin
         state <= `DATA_BITS;
         bitIdx <= 3'b0;
			out_rx <=8'bxxxxxxxx;
         clockCount <= 4'b0;
         receivedData <= 8'b0;
         busy_rx <= 1'b1;
         start_bit_error <= 1'b0;
	      parity_bit_error <= 1'b0;
         framing_stop_error <= 1'b0;
        end
       end
	else if(osm_sel==1'b1) begin
	 if(clockCount==4'b1111) begin
          state <= `DATA_BITS;
          out_rx <= 8'bxxxxxxxx;
          bitIdx <= 3'b0;
          clockCount <= 4'b0;
          receivedData <= 8'b0;
          busy_rx <= 1'b1;
          start_bit_error <= 1'b0;
			 parity_bit_error <= 1'b0;
          framing_stop_error <= 1'b0;
         end
       end
	else if (!(&inputSw) || |clockCount) begin
        // Check bit to make sure it's still low
         if (&inputSw) begin
          start_bit_error <= 1'b1;
          state <= `RESET;
         end
        end
	 clockCount <= clockCount + 4'b1;
        end

            // Wait 8 full cycles to receive serial data
`DATA_BITS: begin
      if(osm_sel==1'b0) begin
      if (clockCount==4'b1100) begin // save one bit of received data
              clockCount <= 4'b0;
               // TODO: check the most popular value
               receivedData[bitIdx] <= inputSw[0]; 
		if (WLS==2'b00) 
		 begin 
		  if (bitIdx==3'b100) 
		   begin
                    bitIdx <= 3'b0;
                    state <= `PARITY_BITS;
	           end 
		  else 
		   begin
                    bitIdx <= bitIdx + 3'b1;
		   end
		  end
    		  if (WLS==2'b01) 
		   begin 
		    if (bitIdx==3'b101) 
		     begin
                      bitIdx <= 3'b0;
                      state <= `PARITY_BITS;
		     end 
		   else 
		    begin
                     bitIdx <= bitIdx + 3'b1;
                    end
	           end				 
		if (WLS==2'b10) 
		 begin 
		  if (bitIdx==3'b110) 
		   begin
                    bitIdx <= 3'b0;
                    state <= `PARITY_BITS;
                   end 
	        else 
		 begin
                  bitIdx <= bitIdx + 3'b1;
                 end
		end
	       if(WLS==2'b11) 
		begin 
		 if(bitIdx==3'b111)
		  begin
                   bitIdx <= 3'b0;
                   state <= `PARITY_BITS;
                  end 
		 else 
		begin
               bitIdx <= bitIdx + 3'b1;
              end
	      end
              end					 
	     else begin
             clockCount <= clockCount + 4'b1;
             end
             end
            else if(osm_sel==1'b1) begin
                if (clockCount==4'b1111) begin // save one bit of received data
                    clockCount <= 4'b0;
                    // TODO: check the most popular value
						  receivedData[bitIdx] <= inputSw[0];            
					  if (WLS==2'b00) 
						 begin 
						  if (bitIdx==3'b100) 
							begin
                        bitIdx <= 3'b0;
								busy_rx<=1'b1;
						      done_rx<=1'b0;
                        state <= `PARITY_BITS;
							end 
						  else 
							begin
							 busy_rx<=1'b1;
						    done_rx<=1'b0;
                      bitIdx <= bitIdx + 3'b1;
							end
						end
    				if (WLS==2'b01) 
						  begin 
						  if (bitIdx==3'b101) 
							begin
								busy_rx<=1'b1;
						      done_rx<=1'b0;
                        bitIdx <= 3'b0;
                        state <= `PARITY_BITS;
							end 
							else 
							 begin
							   busy_rx<=1'b1;
						      done_rx<=1'b0;
                        bitIdx <= bitIdx + 3'b1;
                      end
						 end				 
					 if (WLS==2'b10) 
					  begin 
						if (bitIdx==3'b110) 
						 begin
                        bitIdx <= 3'b0;
								busy_rx<=1'b1;
						      done_rx<=1'b0;
                        state <= `PARITY_BITS;
                   end 
						else 
						 begin
						 busy_rx<=1'b1;
						 done_rx<=1'b0;
                   bitIdx <= bitIdx + 3'b1;
                   end
					 end
					if(WLS==2'b11) 
					 begin 
				    if(bitIdx==3'b111)
					 begin
                    bitIdx <= 3'b0;
						  busy_rx<=1'b1;
						  done_rx<=1'b0;
                    state <= `PARITY_BITS;
                end 
					 else 
					  begin
                        bitIdx <= bitIdx + 3'b1;
								busy_rx<=1'b1;
				     		  done_rx<=1'b0;
                 end
					  end
              end
					  else begin
                    clockCount <= clockCount + 4'b1;
						  busy_rx<=1'b1;
						  done_rx<=1'b0;
                end
            end
				end

`PARITY_BITS : begin
	       if(PEN==1'b0)
		begin
		 busy_rx    <= 1'b1;
		 done_rx<=1'b0;
		 state   <= `STOP_BIT;
		end 
	       else begin
		if(SP==1'b0) 
		 begin
		  if(EPS==1'b0)
		   begin
		    if(parity_check==1'b1)
		     begin
		      busy_rx    <= 1'b1;
		      done_rx<=1'b0;
				state   <= `STOP_BIT;
		     end
		    else
		     begin
		      parity_bit_error <= 1'b1;
		      done_rx<=1'b0;
				state  <= `STOP_BIT;
		     end
		    end 
		    else 	
		     begin
		      if(parity_check==1'b0)
		       begin
			busy_rx  <= 1'b1;
				done_rx<=1'b0;
			state <= `STOP_BIT;
		       end
		     else 
		      begin
			parity_bit_error<=1'b1;
			done_rx<=1'b0;
			state   <= `STOP_BIT;
		      end
		     end
	            end
		    else begin 
		     if(EPS==1'b0 && inputSw[0]==1'b1)
		      begin
		       busy_rx <= 1'b1;
		       done_rx<=1'b0;
				 state   <= `STOP_BIT;
		      end
		    else if(EPS==1'b1 && inputSw[0]==1'b0)
		     begin
		      busy_rx <= 1'b1;
				done_rx<=1'b0;
		      state   <= `STOP_BIT;
		     end
		    else 
		     begin
		      parity_bit_error <= 1'b1;
		      done_rx<=1'b0;
				state   <= `STOP_BIT;
		     end
		    end
		   end
		  end
/*
* Baud clock may not be running at exactly the same rate as the
* transmitter. Next start bit is allowed on at least half of stop bit.
*/

`STOP_BIT: begin
           if (&clockCount || (clockCount >= 4'h8 && !(|inputSw))) begin
            state <= `IDLE;
            done_rx <= 1'b1;
            busy_rx <= 1'b0;
            out_rx <= receivedData;
            clockCount <= 4'b0;
           end else begin
           clockCount <= clockCount + 1;
                    // Check bit to make sure it's still high
            if (!(|inputSw)) begin
             framing_stop_error <= 1'b1;
             state <= `RESET;
            end
            end
            end

default: state <= `IDLE;
endcase
end

endmodule