
module parameterControl(

	input clk,
	input reset_n,
	
	input [31:0] coef_mux,
	
	input [31:0] parameter_in_0,
	input [31:0] parameter_in_1,
	input [31:0] parameter_in_2,
	input [31:0] parameter_in_3,
	input [31:0] parameter_in_4,
	input [31:0] parameter_in_5,
	input [31:0] parameter_in_6,
	input [31:0] parameter_in_7,
	input [31:0] parameter_in_8,
	input [31:0] parameter_in_9,
	
	output reg bypass_filter,

	output reg [31:0] parameter_out_0,
	output reg [31:0] parameter_out_1,
	output reg [31:0] parameter_out_2,
	output reg [31:0] parameter_out_3,
	output reg [31:0] parameter_out_4,
	output reg [31:0] parameter_out_5,
	output reg [31:0] parameter_out_6,
	output reg [31:0] parameter_out_7,
	output reg [31:0] parameter_out_8,
	output reg [31:0] parameter_out_9,
	output reg [31:0] parameter_out_10,
	output reg [31:0] parameter_out_11,
	output reg [31:0] parameter_out_12,
	output reg [31:0] parameter_out_13,
	output reg [31:0] parameter_out_14,
	output reg [31:0] parameter_out_15,
	output reg [31:0] parameter_out_16,
	output reg [31:0] parameter_out_17,
	output reg [31:0] parameter_out_18,
	output reg [31:0] parameter_out_19,
	output reg [31:0] parameter_out_20,
	output reg [31:0] parameter_out_21,
	output reg [31:0] parameter_out_22,
	output reg [31:0] parameter_out_23,
	output reg [31:0] parameter_out_24,
	output reg [31:0] parameter_out_25,
	output reg [31:0] parameter_out_26,
	output reg [31:0] parameter_out_27,
	output reg [31:0] parameter_out_28,
	output reg [31:0] parameter_out_29,
	output reg [31:0] parameter_out_30,
	output reg [31:0] parameter_out_31,
	output reg [31:0] parameter_out_32
);


always @ (posedge clk)
begin

	if ( coef_mux == 0 )
		bypass_filter <= 1;
		
	else if ( coef_mux == 1 )
	begin
		parameter_out_0 <= parameter_in_0;
		parameter_out_1 <= parameter_in_1;
		parameter_out_2 <= parameter_in_2;
		parameter_out_3 <= parameter_in_3;
		parameter_out_4 <= parameter_in_4;
		parameter_out_5 <= parameter_in_5;
		parameter_out_6 <= parameter_in_6;
		parameter_out_7 <= parameter_in_7;
		parameter_out_8 <= parameter_in_8;	
		parameter_out_9 <= parameter_in_9;
		bypass_filter <= 0;
	end
	
	else if ( coef_mux == 2 )
	begin
		parameter_out_10 <= parameter_in_0;
		parameter_out_11 <= parameter_in_1;
		parameter_out_12 <= parameter_in_2;
		parameter_out_13 <= parameter_in_3;
		parameter_out_14 <= parameter_in_4;
		parameter_out_15 <= parameter_in_5;
		parameter_out_16 <= parameter_in_6;
		parameter_out_17 <= parameter_in_7;
		parameter_out_18 <= parameter_in_8;	
		parameter_out_19 <= parameter_in_9;
		bypass_filter <= 0;
	
	end
	
	else if ( coef_mux == 3 )
	begin
		parameter_out_20 <= parameter_in_0;
		parameter_out_21 <= parameter_in_1;
		parameter_out_22 <= parameter_in_2;
		parameter_out_23 <= parameter_in_3;
		parameter_out_24 <= parameter_in_4;
		parameter_out_25 <= parameter_in_5;
		parameter_out_26 <= parameter_in_6;
		parameter_out_27 <= parameter_in_7;
		parameter_out_28 <= parameter_in_8;	
		parameter_out_29 <= parameter_in_9;
		bypass_filter <= 0;
	
	end
	
	else if ( coef_mux == 4 )
	begin
		parameter_out_30 <= parameter_in_0;
		parameter_out_31 <= parameter_in_1;
		parameter_out_32 <= parameter_in_2;	
		bypass_filter <= 0;
	end



end



endmodule


