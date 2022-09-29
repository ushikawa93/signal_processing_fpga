
module ruido_LU_table(
	
	input clk,
	output [31:0] dato_ruidoso
	
	);
	
reg [31:0] data_out_reg;
reg [31:0] buffer [0:16383];

	initial $readmemh( "LU_Tables/ruido_14bits_16384ptos.mem",buffer );
	
integer i; initial i=0;

always @ (posedge clk)
begin
	
	i<= (i==16383)? 0 : i+1;
	data_out_reg <= buffer[i];

end

assign dato_ruidoso = data_out_reg;


endmodule
	