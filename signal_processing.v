
/* ==========================================================================
 * ====================== Módulo de Procesamiento FIR ========================
 *  Descripción general:
 *    Este módulo realiza el procesamiento principal de la señal mediante un
 *    filtro FIR de 32 orden. Ajusta los niveles de señal de entrada y salida
 *    para adaptarse a los rangos requeridos por los ADCs y DACs.
 *    Los coeficientes del filtro se registran al inicio para evitar cambios
 *    durante la operación.
 *
 *  Señales principales:
 *    - clk, reset_n, enable_gral: control de reloj, reset y habilitación general.
 *    - bypass: permite omitir el filtrado FIR.
 *    - data_in, data_in_valid: datos de entrada al módulo.
 *    - data_out1, data_out1_valid, data_out2, data_out2_valid: salidas
 *      procesadas.
 *    - ready_to_calculate, processing_finished: indicadores de estado
 *      (siempre activos en este ejemplo).
 *     - parameter_in_0 .. parameter_in_32: coeficientes del filtro FIR de entrada.
 *      - parameter_out_0 .. parameter_out_4: parámetros de salida (no usados
 *      en este ejemplo, asignados a 0).
 *
 *  Funcionamiento:
 *    1. Se registran los coeficientes del filtro al inicio mediante reset.
 *    2. La entrada se ajusta restando un offset, se procesa en FIR y luego se
 *       suma un offset de salida.
 *    3. Los resultados se limitan a los valores mínimos y máximos definidos.
 *    4. El módulo soporta bypass para pruebas o contingencias.
 *
 *  Observaciones:
 *    - La señal de ready_to_calculate y processing_finished están fijadas en 1
 *      ya que el procesamiento es continuo y no bloqueante.
 *    - Los coeficientes se mantienen fijos durante la operación para garantizar
 *      consistencia.
 *	 - En este módulo podría reemplazarse el FIR por otro tipo de procesamiento
 *	 - De esta manera se mantiene la interfaz general y se cambia el procesamiento
 * ========================================================================== */ 


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

/* ============================================================================
 * ====================== Registro parametros en reset ========================
 *  Lo hago asi para que no se modifiquen en medio de la operacion
 *  capaz sería mejor registrarlos con un enable mas que con un reset... 
 *  igual es sincronico asique no creo que genere cosas raras.
 =============================================================================== 
*/


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


/* ============================================================================
 *  ================================= Procesamiento ============================
 *  Los calculos se hacen con señales al ededor del 0 y el ADC y DAC requieren señales positivas, 
 *  por eso aca hago un poco de magia digital para acomodar niveles de señal 
 *  (resto offset sumo offset y me fijo que la cosa no sature )
 =============================================================================== 
*/

parameter offset_in = 8192;
parameter offset_out = 8192;
parameter low_threshold = 0;
parameter high_threshold = 14612;

wire signed [31:0] data_out_fir;
wire data_out_fir_valid;

wire signed [31:0] data_in_fir;
wire data_in_fir_valid;

assign data_in_fir = data_in - offset_in;
assign data_in_fir_valid = data_in_valid;

wire [31:0] data_out_intermedia = data_out_fir + offset_out;


assign data_out1 = ( data_out_intermedia < low_threshold ) ? low_threshold  : ( (data_out_intermedia > high_threshold) ? high_threshold :  data_out_intermedia ) ;
assign data_out1_valid = data_out_fir_valid;


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


	.data_in(data_in_fir),
	.data_in_valid(data_in_fir_valid),
	
	.data_out(data_out_fir),
	.data_out_valid(data_out_fir_valid),


);

/* ==================================================================================
 * ================================= Salidas auxiliares =============================
 *  Este procesamiento no hace nada raro asique siempre esta listo para calcular 
 *  y siempre tiene los calculos listos. Estas señales servitrían si no fuera el caso
 =================================================================================== */

wire ready_fase,ready_cuadratura;
wire finished_fase,finished_cuadratura;

assign ready_to_calculate = 1; 
assign processing_finished = 1; 

assign parameter_out_0 = 0;
assign parameter_out_1 = 0;
assign parameter_out_2 = 0;
assign parameter_out_3 = 0;
assign parameter_out_4 = 0;

endmodule

