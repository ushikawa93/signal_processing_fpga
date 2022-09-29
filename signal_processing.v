
module signal_processing(

	input clk,
	input reset_n,
	input enable_gral,	
	
	input [63:0] data_in,
	input 		 data_in_valid,
	
	output [63:0] data_out,
	output		  data_out_valid,
	
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
	input [31:0] parameter_in_10,
	
	output [31:0] parameter_out_0,
	output [31:0] parameter_out_1,
	output [31:0] parameter_out_2,
	output [31:0] parameter_out_3,
	output [31:0] parameter_out_4
		

);

////////////////////////////////////////////////////////////////
// ================ Registro parametros en reset ===============
////////////////////////////////////////////////////////////////


reg[31:0] parameter_0_reg,parameter_1_reg,parameter_2_reg,parameter_3_reg,parameter_4_reg,parameter_5_reg;
reg[31:0] parameter_6_reg,parameter_7_reg,parameter_8_reg,parameter_9_reg,parameter_10_reg;

always @ (posedge clk)
begin

	if(!reset_n)
	begin
		parameter_0_reg <= parameter_in_0;
		parameter_1_reg <= parameter_in_1;
		parameter_2_reg <= parameter_in_2;
		parameter_3_reg <= parameter_in_3;
		parameter_4_reg <= parameter_in_4;
		parameter_5_reg <= parameter_in_5;
		parameter_6_reg <= parameter_in_6;
		parameter_7_reg <= parameter_in_7;
		parameter_8_reg <= parameter_in_8;
		parameter_9_reg <= parameter_in_9;
		parameter_10_reg <= parameter_in_10;
	end

end

//////////////////////////////////////////////////
// ================ Procesamiento ===============
//////////////////////////////////////////////////

wire ready,fifo_lleno;

filtro_promedio_movil process(

	// Entradas de control
	.clock(clk),
	.reset_n(reset_n),
	.enable(enable_gral),
	
	// Parametros de configuracion
	.ptos_x_ciclo(parameter_0_reg),
	.frames_integracion(parameter_1_reg),
	
	// Entrada avalon streaming 
	.data_valid(data_in_valid),
	.data(data_in),	
		
	// Salida avalon streaming
	.data_out(data_out),
	.data_out_valid(data_out_valid),

	// Salidas auxiliares
	.ready(ready),
	.fifo_lleno(fifo_lleno)

);


//////////////////////////////////////////////////
// ================ Salidas auxiliares ===============
//////////////////////////////////////////////////

assign parameter_out_0 = ready;
assign parameter_out_1 = fifo_lleno;
assign parameter_out_2 = 0;
assign parameter_out_3 = 0;
assign parameter_out_4 = 0;


endmodule

