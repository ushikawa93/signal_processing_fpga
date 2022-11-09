
module signal_processing(

	input clk,
	input reset_n,
	input enable_gral,	
	
	input bypass,
	
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
	input [31:0] parameter_in_11,
	input [31:0] parameter_in_12,
	input [31:0] parameter_in_13,
	input [31:0] parameter_in_14,
	input [31:0] parameter_in_15,
	input [31:0] parameter_in_16,
	input [31:0] parameter_in_17,
	input [31:0] parameter_in_18,
	input [31:0] parameter_in_19,
	
	input [31:0] parameter_in_20,
	input [31:0] parameter_in_21,
	input [31:0] parameter_in_22,
	input [31:0] parameter_in_23,
	input [31:0] parameter_in_24,
	input [31:0] parameter_in_25,
	input [31:0] parameter_in_26,
	input [31:0] parameter_in_27,
	input [31:0] parameter_in_28,
	input [31:0] parameter_in_29,
	
	input [31:0] parameter_in_30,
	input [31:0] parameter_in_31,
	input [31:0] parameter_in_32,
	
	
	output [31:0] parameter_out_0,
	output [31:0] parameter_out_1,
	output [31:0] parameter_out_2,
	output [31:0] parameter_out_3,
	output [31:0] parameter_out_4
		

);

////////////////////////////////////////////////////////////////
// ================ Registro parametros en reset ===============
////////////////////////////////////////////////////////////////


reg[31:0] parameter_0_reg,parameter_1_reg,parameter_2_reg,parameter_3_reg,parameter_4_reg,parameter_5_reg,parameter_6_reg,parameter_7_reg,parameter_8_reg,parameter_9_reg;
reg[31:0] parameter_10_reg,parameter_11_reg,parameter_12_reg,parameter_13_reg,parameter_14_reg,parameter_15_reg,parameter_16_reg,parameter_17_reg,parameter_18_reg,parameter_19_reg;
reg[31:0] parameter_20_reg,parameter_21_reg,parameter_22_reg,parameter_23_reg,parameter_24_reg,parameter_25_reg,parameter_26_reg,parameter_27_reg,parameter_28_reg,parameter_29_reg;
reg[31:0] parameter_30_reg,parameter_31_reg,parameter_32_reg;

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
		parameter_11_reg <= parameter_in_11;
		parameter_12_reg <= parameter_in_12;
		parameter_13_reg <= parameter_in_13;
		parameter_14_reg <= parameter_in_14;
		parameter_15_reg <= parameter_in_15;
		parameter_16_reg <= parameter_in_16;
		parameter_17_reg <= parameter_in_17;
		parameter_18_reg <= parameter_in_18;
		parameter_19_reg <= parameter_in_19;
		
		parameter_20_reg <= parameter_in_20;
		parameter_21_reg <= parameter_in_21;
		parameter_22_reg <= parameter_in_22;
		parameter_23_reg <= parameter_in_23;
		parameter_24_reg <= parameter_in_24;
		parameter_25_reg <= parameter_in_25;
		parameter_26_reg <= parameter_in_26;
		parameter_27_reg <= parameter_in_27;
		parameter_28_reg <= parameter_in_28;
		parameter_29_reg <= parameter_in_29;
		
		parameter_30_reg <= parameter_in_30;
		parameter_31_reg <= parameter_in_31;
		parameter_32_reg <= parameter_in_32;
		
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



FIR_filter filtro (

	.clk(clk),
	.reset_n(reset_n),
	.enable(enable_gral),
	.bypass(bypass),
	
	.coef_0(parameter_0_reg),
	.coef_1(parameter_1_reg),
	.coef_2(parameter_2_reg),
	.coef_3(parameter_3_reg),
	.coef_4(parameter_4_reg),
	.coef_5(parameter_5_reg),
	.coef_6(parameter_6_reg),
	.coef_7(parameter_7_reg),
	.coef_8(parameter_8_reg),	
	.coef_9(parameter_9_reg),
	
	.coef_10(parameter_10_reg),
	.coef_11(parameter_11_reg),
	.coef_12(parameter_12_reg),
	.coef_13(parameter_13_reg),
	.coef_14(parameter_14_reg),
	.coef_15(parameter_15_reg),
	.coef_16(parameter_16_reg),
	.coef_17(parameter_17_reg),	
	.coef_18(parameter_18_reg),
	.coef_19(parameter_19_reg),
	
	.coef_20(parameter_20_reg),
	.coef_21(parameter_21_reg),
	.coef_22(parameter_22_reg),
	.coef_23(parameter_23_reg),
	.coef_24(parameter_24_reg),
	.coef_25(parameter_25_reg),
	.coef_26(parameter_26_reg),	
	.coef_27(parameter_27_reg),
	.coef_28(parameter_28_reg),
	.coef_29(parameter_29_reg),
	
	.coef_30(parameter_30_reg),
	.coef_31(parameter_31_reg),
	.coef_32(parameter_32_reg),


	.data_in(data_in),
	.data_in_valid(data_in_valid),
	
	.data_out(data_out1),
	.data_out_valid(data_out1_valid),


);


/*

prom_coherente_pipelined promC(
	
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

//assign data_sen_mixer = data_out_promC;
//assign data_cos_mixer = data_out_promC;
//assign data_out_mixer_valid = data_out_promC_valid;




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
*/


//////////////////////////////////////////////////
// ================ Salidas auxiliares ===============
//////////////////////////////////////////////////

wire ready_fase,ready_cuadratura;
wire finished_fase,finished_cuadratura;

assign ready_to_calculate = 1; // (ready_fase && ready_cuadratura);
assign processing_finished = 1; // (finished_fase && finished_cuadratura);

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

