`include "DIVISOR_LATCH_LS.v"
`include "DIVISOR_LATCH_MS.v"
`include "BAUD_RATE_GENERATOR.v"
`include "FIFO_CONTROL_REGISTER.v"
`include "TRANSMITTER_HOLDING_REGISTER.v"

module UART_CORE(framing_stop_error,parity_bit_error,start_bit_error,done_rx,busy_rx,in_rx,data_out,m_clk,reset,address,data_in,out_tx,busy_tx,done_tx,rx_clk);

//port connections
input wire in_rx;
input wire m_clk,reset;
input wire [15:0] address;
input wire [7:0] data_in;
output reg [7:0] data_out;
output reg rx_clk;
output reg out_tx;
output reg busy_tx;
output reg done_tx;
output reg busy_rx;
output reg done_rx;
output  start_bit_error;
output parity_bit_error;
output framing_stop_error;

//internal wires
wire busy_rx_1;
wire done_rx_1;
wire [7:0] divisor_1;
wire [7:0] divisor_2;
wire DMA_MODE,TXCLR,RXCLR,FIFOEN;
wire [3:0] RXFIFTL;
wire [1:0] WLS;
wire [7:0] data_out_reg;
wire [7:0] data_out_fifo;
wire [7:0] data_out_sel_1;
wire [7:0] data_out_sel_2;
wire [7:0] data_out_rx_reg;
wire [7:0] data_out_rx_fifo;
wire out;
wire start;
wire [3:0] bitIdx_1;
wire [7:0] line_status_wire;
wire wr_full_RX_1;
wire [7:0] out_rx;
wire wr_full_tx;
reg in_rx_reg;
wire rx_clk_1;

//modules inside uart
DIVISOR_LATCH_LS X1(.divisor_1(divisor_1),.m_clk(m_clk),.reset(reset),.address(address),.data_in(data_in));
DIVISOR_LATCH_MS X2(.divisor_2(divisor_2),.m_clk(m_clk),.reset(reset),.address(address),.data_in(data_in));
BAUD_RATE_GENERATOR X3(.divisor_1(divisor_1),.divisor_2(divisor_2),.m_clk(m_clk),.reset(reset),.tx_clk(tx_clk),.rx_clk(rx_clk_1));
FIFO_CONTROL_REGISTER X4(.DMA_MODE(DMA_MODE),.RXFIFTL(RXFIFTL),.TXCLR(TXCLR),.RXCLR(RXCLR),.FIFOEN(FIFOEN),.m_clk(m_clk),.data_in(data_in),.reset(reset),.address(address));
LINE_CONTROL_REGISTER X5(.osm_sel(osm_sel),.bitIdx_1(bitIdx_1),.reset(reset),.address(address),.m_clk(m_clk),.data_in(data_in),.WLS(WLS),.STB(STB),.PEN(PEN),.EPS(EPS),.SP(SP),.BC(BC));
TRANSMITTER_HOLDING_REGISTER X6(.m_clk(m_clk),.reset(reset),.data_in(data_in),.address(address),.data_out_reg(data_out_reg));
RECIEVER_BUFFER_REGISTER X7(.m_clk(m_clk),.reset(reset),.data_in(out_rx),.address(address),.data_out_reg(data_out_rx_reg));

LINE_STATUS_REGISTER X14(.address(address),.data_out_reg(line_status_wire),.wr_full_tx(wr_full_tx),.FIFO_EN(FIFOEN),.wr_full_RX(wr_full_RX_1),.rd_empty_RX(rd_empty_RX),.trigger_RX(trigger),.start_bit_error(start_bit_error),.parity_bit_error(parity_bit_error),.framing_stop_error(framing_stop_error),.m_clk(m_clk),.reset(reset));

//tx shift and timing
TRANSMITTER_TIMING_AND_SHIFT_REGISTER X8(.m_clk(tx_clk),.reset(reset),.PEN(PEN),.EPS(EPS),.BC(BC),.STB(STB),.SP(SP),.WLS(WLS),.start(start),.data_in(data_out_sel_1),.out(out),.done(done),.busy(busy));

//rx shift and timing
RECIEVER_TIMING_AND_SHIFT_REGISTER X9(.EPS(EPS),.PEN(PEN),.SP(SP),.WLS(WLS),.clk(rx_clk),.reset(reset),.in(in_rx),.osm_sel(osm_sel),.out_rx(out_rx),.done_rx(done_rx_1),.busy_rx(busy_rx_1),.start_bit_error(start_bit_error),.parity_bit_error(parity_bit_error),.framing_stop_error(framing_stop_error));

//for selection between transmitter hold register and fifo_tx
SELECT X10(.FIFO_EN(FIFOEN),.DMA_MODE(DMA_MODE),.data_in_1(data_out_reg),.data_in_2(data_out_fifo),.m_clk(m_clk),.reset(reset),.data_out(data_out_sel_1));

//For slection between receiver buffer register and fifo_rx (incomplete)
SELECT X11(.FIFO_EN(FIFOEN),.DMA_MODE(DMA_MODE),.data_in_1(data_out_rx_reg),.data_in_2(data_out_rx_fifo),.m_clk(m_clk),.reset(reset),.data_out(data_out_sel_2));

//FIFO_TX
FIFO_TX X12(.bitIdx_1(bitIdx_1),.start(start),.data_out_fifo(data_out_fifo),.wr_full(wr_full_tx),.rd_empty(rd_empty),.FIFO_EN(FIFOEN),.data_in(data_in),.address(address),.rd_clk(tx_clk),.wr_clk(m_clk),.reset(reset),.clr(TXCLR)); 

//FIFO_RX
FIFO_RX X13(.trigger(trigger),.RXFIFTL(RXFIFTL),.data_out_fifo_RX(data_out_rx_fifo),.wr_full_RX(wr_full_RX_1),.rd_empty_RX(rd_empty_RX),.FIFO_EN_RX(FIFOEN),.data_in(out_rx),.address(address),.rd_clk(rx_clk), .wr_clk(rx_clk),.reset(reset),.clr(RXCLR));

always @(posedge tx_clk)
 begin
	busy_tx	<=	busy;
	done_tx <=	done;
	busy_rx <= busy_rx_1;
	done_rx <= done_rx_1;
	out_tx <= out;
	//data_out <= data_out_sel_2;

 end	
 
 
always @(posedge m_clk)
begin
   rx_clk<=rx_clk_1;
	if(address==16'h0004)
   begin
	data_out <= line_status_wire;
   end
end
	
endmodule