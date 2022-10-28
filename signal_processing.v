
module signal_processing(

	input clk,
	input reset_n,
	input enable_gral,	
	
	input [63:0] data_in,
	input 		 data_in_valid,
	
	output [63:0] data_out1,
	output		  data_out1_valid,
	
	output [63:0] data_out2,
	output		  data_out2_valid,
	
	output ready_to_calculate,
	output processing_finished,
	
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

wire data_out_mixer_valid;
wire signed [63:0] data_sen_mixer;
wire signed [63:0] data_cos_mixer;

wire signed [63:0] data_out_promC;
wire data_out_promC_valid;

prom_coherente_pipelined(
	
	// Entradas de control
	.clk(clk),
	.reset(reset_n),
	.enable(enable_gral),
	
	// Parametros de configuracion
	.ptos_x_ciclo(parameter_0_reg),
	.frames_prom_coherente(parameter_2_reg),
	
	// Entrada avalon streaming
	.data_in_valid(data_in_valid),
	.data_in(data_in),
	
	// Salida avalon streaming 
	.data_out_valid(data_out_promC_valid),
	.data_out(data_out_promC)	
	
);


reference_mixer mezclador(

	// Entradas de control
	.clock(clk),
	.reset_n(reset_n),
	.enable(enable_gral),
	
	// Parametros de configuracion
	.ptos_x_ciclo(parameter_0_reg),
	
	// Entrada avalon streaming
	.data(data_out_promC),	
	.data_valid(data_out_promC_valid),	
		
	// Salidas avalon streaming 
	.data_out_seno(data_sen_mixer),
	.data_out_coseno(data_cos_mixer),
	.data_valid_multiplicacion(data_out_mixer_valid)	

);


 filtro_promedio_movil filtro_fase(

	// Entradas de control
	.clock(clk),
	.reset_n(reset_n),
	.enable(enable_gral),
	
	// Parametros de configuracion
	.ptos_x_ciclo(parameter_0_reg),
	.frames_integracion(parameter_1_reg),
	
	// Entrada avalon streaming 
	.data_valid(data_out_mixer_valid),
	.data(data_sen_mixer),	
		
	// Salida avalon streaming
	.data_out(data_out1),
	.data_out_valid(data_out1_valid),
	
	// Salida auxiliar
	.fifo_lleno(finished_fase),
	.ready_to_calculate(ready_cuadratura)

);

filtro_promedio_movil filtro_cuadratura(

	// Entradas de control
	.clock(clk),
	.reset_n(reset_n),
	.enable(enable_gral),
	
	// Parametros de configuracion
	.ptos_x_ciclo(parameter_0_reg),
	.frames_integracion(parameter_1_reg),
	
	// Entrada avalon streaming 
	.data_valid(data_out_mixer_valid),
	.data(data_cos_mixer),	
		
	// Salida avalon streaming
	.data_out(data_out2),
	.data_out_valid(data_out2_valid),
	
	// Salida auxiliar
	.fifo_lleno(finished_cuadratura),
	.ready_to_calculate(ready_fase)

);



//////////////////////////////////////////////////
// ================ Salidas auxiliares ===============
//////////////////////////////////////////////////

wire ready_fase,ready_cuadratura;
wire finished_fase,finished_cuadratura;

assign ready_to_calculate = (ready_fase && ready_cuadratura);
assign processing_finished = (finished_fase && finished_cuadratura);

assign parameter_out_0 = 0;
assign parameter_out_1 = 0;
assign parameter_out_2 = 0;
assign parameter_out_3 = 0;
assign parameter_out_4 = 0;


//////////////////////////////////////////////////
// ================ Sin procesamiento ===============
//////////////////////////////////////////////////
/*
assign data_out1 = data_in;
assign data_out1_valid = data_in_valid;

assign data_out2 = data_in;
assign data_out2_valid = data_in_valid;

assign ready_to_calculate = 1;

*/


endmodule

