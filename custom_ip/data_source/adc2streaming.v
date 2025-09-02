
module adc2streaming(

	input clk,
	input reset,
	input sinc,
	input [31:0] data_in,

	output 	  [31:0] data_out0,
	output 			 	data_out_valid0,
	input 			 	data_ready0
);

reg sinc_past,sinc_past_past; initial sinc_past = 0;
reg [31:0] data_in_reg;
assign data_out0 = data_in_reg;

assign data_out_valid0 = ((reset == 1) && ( (sinc_past_past == 0)&&(sinc_past == 1) ) );


always @ (posedge clk)
begin
	data_in_reg <= data_in;
	sinc_past <= sinc;
	sinc_past_past <= sinc_past;
end

endmodule
