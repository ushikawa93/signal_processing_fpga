
module signal_processing_template(

	////////// CLK /////////
	input clk,
	
	 ///////// SW /////////
   input       [3:0]  SW,
	
	///////// KEYS ////////
	input 		[1:0] KEY,
	
	///////// LED /////////
	output		[3:0] LED,
	
	
	//////// HPS ////////////
	 output      [14:0] HPS_DDR3_ADDR,
    output      [2:0]  HPS_DDR3_BA,
    output             HPS_DDR3_CAS_N,
    output             HPS_DDR3_CKE,
    output             HPS_DDR3_CK_N,
    output             HPS_DDR3_CK_P,
    output             HPS_DDR3_CS_N,
    output      [3:0]  HPS_DDR3_DM,
    inout       [31:0] HPS_DDR3_DQ,
    inout       [3:0]  HPS_DDR3_DQS_N,
    inout       [3:0]  HPS_DDR3_DQS_P,
    output             HPS_DDR3_ODT,
    output             HPS_DDR3_RAS_N,
    output             HPS_DDR3_RESET_N,
    input              HPS_DDR3_RZQ,
    output             HPS_DDR3_WE_N,
	
	 		
	//////// Highspeed ADC_DAC //////
	 
   output 		    ADC_CLK_A,
	input    [13:0] ADC_DA,
	output			 ADC_OEB_A,
	input				 ADC_OTR_A,
	
	output			 ADC_CLK_B,
	input	 	[13:0] ADC_DB,
	output			 ADC_OEB_B,
	input				 ADC_OTR_B,
		
	output			 DAC_CLK_A,
	output   [13:0] DAC_DA,
	output			 DAC_WRT_A,
	
	output 			 DAC_CLK_B,
	output   [13:0] DAC_DB,
	output			 DAC_WRT_B,
	
	output			 DAC_MODE,
	output			 OSC_SMA_ADC4,
	output			 POWER_ON,
	output			 SMA_DAC4,
	
	// Entradas y salidas de ADC 2308	
	output	adc_cs_n,
	output	adc_sclk,
	output	adc_din,
	input 	adc_dout
);


////////////////////////////////////////////////
// ============= Interfaz de control  =============
////////////////////////////////////////////////

wire enable;
	assign enable = enable_from_control && ready_to_calculate;
wire reset_n;
	assign reset_n = !reset_from_control && reset_physical;

	
wire enable_from_control;
wire clk_custom;
wire reset_from_control;
wire reset_physical = KEY[0];

wire [31:0] amplitud_ruido;
wire [31:0] frames_integracion;

control nios (

	 // Logica de control
	 .clk							(clk),
	 .reset_n					(reset_physical),	
	 .enable						(enable_from_control),
	 .clk_custom				(clk_custom),
	 .reset_from_control		(reset_from_control),
	 .calculo_finalizado 	(calculo_finalizado),
	 
	 // Parametros reconfigurables
	 .parameter_out_0			(amplitud_ruido),
	 .parameter_out_1			(frames_integracion),
	
	 // Resultados de procesamiento de 32 bits
	 .result_0_32_bit			(datos_simulados),
	 .result_0_32_bit_valid	(datos_simulados_valid),
	
	 .result_1_32_bit			(data_adc_2308),
	 .result_1_32_bit_valid (data_adc_2308_valid),
	 
	 .result_0_64_bit			(data_procesada1),
	 .result_0_64_bit_valid	(data_procesada1_valid),
	 
	 .result_1_64_bit			(data_procesada2),
	 .result_1_64_bit_valid	(data_procesada2_valid),

	 // Memoria DDR3 del HPS
	 .HPS_DDR3_ADDR         (HPS_DDR3_ADDR),                          //          memory.mem_a
	 .HPS_DDR3_BA           (HPS_DDR3_BA),                         //                .mem_ba
	 .HPS_DDR3_CK_P         (HPS_DDR3_CK_P),                         //                .mem_ck
	 .HPS_DDR3_CK_N         (HPS_DDR3_CK_N),                       //                .mem_ck_n
	 .HPS_DDR3_CKE          (HPS_DDR3_CKE),                        //                .mem_cke
	 .HPS_DDR3_CS_N         (HPS_DDR3_CS_N),                       //                .mem_cs_n
	 .HPS_DDR3_RAS_N        (HPS_DDR3_RAS_N),                      //                .mem_ras_n
	 .HPS_DDR3_CAS_N        (HPS_DDR3_CAS_N),                      //                .mem_cas_n
	 .HPS_DDR3_WE_N         (HPS_DDR3_WE_N),                       //                .mem_we_n
	 .HPS_DDR3_RESET_N      (HPS_DDR3_RESET_N),                    //                .mem_reset_n
	 .HPS_DDR3_DQ           (HPS_DDR3_DQ),                         //                .mem_dq
	 .HPS_DDR3_DQS_P        (HPS_DDR3_DQS_P),                        //                .mem_dqs
	 .HPS_DDR3_DQS_N        (HPS_DDR3_DQS_N),                      //                .mem_dqs_n
	 .HPS_DDR3_ODT          (HPS_DDR3_ODT),                        //                .mem_odt
	 .HPS_DDR3_DM           (HPS_DDR3_DM),                         //                .mem_dm
	 .HPS_DDR3_RZQ          (HPS_DDR3_RZQ),                      //                
		
);


////////////////////////////////////////////////
// ====== Interfaz de datos de entrada  =========
////////////////////////////////////////////////

data_in data(

	// Entradas de control
	.reset_n(reset_n),
	.enable(enable),
	
	// Entradas de reloj
	.clk_sim(clk_custom),
	.clk_dac(clk_custom),
	.clk_adc(clk_custom),
	.clk_adc_2308(clk_custom),
		
	// Parametros de configuracion -> Podrian conectarse a el Nios o HPS si quisieramos...
	.simulation_noise_bits(amplitud_ruido),
	.ptos_x_ciclo_sim(32),
	.metodo_ruido(0),
	.ptos_x_ciclo_dac(32),
	.sincronizar_adc_con_dac(1),
	.f_muestreo_2308(1000),
	.sel_ch_2308(0),	
	
	// Salida avalon streaming simulacion
	.simulation_data_valid(datos_simulados_valid),
	.simulation_data(datos_simulados),
	
	// Salida avalon streaming ADC
	.data_canal_a(data_canal_a),
	.data_canal_b(data_canal_b),
	.data_adc_valid(data_adc_valid),
	
	// Salida avalon streaming	ADC 2308
	.data_adc_2308_valid(data_adc_2308_valid),
	.data_adc_2308(data_adc_2308),
	
	
	
	// Entradas y salidas del ADC/DAC HIghSPEED
	.ADC_CLK_A(ADC_CLK_A),
	.ADC_DA(ADC_DA),
	.ADC_OEB_A(ADC_OEB_A),
	.ADC_OTR_A(ADC_OTR_A),
	
	.ADC_CLK_B(ADC_CLK_B),
	.ADC_DB(ADC_DB),
	.ADC_OEB_B(ADC_OEB_B),
	.ADC_OTR_B(ADC_OTR_B),
		
	.DAC_CLK_A(DAC_CLK_A),
	.DAC_DA(DAC_DA),
	.DAC_WRT_A(DAC_WRT_A),
	
	.DAC_CLK_B(DAC_CLK_B),
	.DAC_DB(DAC_DB),
	.DAC_WRT_B(DAC_WRT_B),
	
	.DAC_MODE(DAC_MODE),
	.OSC_SMA_ADC4(OSC_SMA_ADC4),
	.POWER_ON(POWER_ON),
	.SMA_DAC4(SMA_DAC4),
	
	// Entradas y salidas del ADC 2308
	.adc_cs_n(adc_cs_n),
	.adc_sclk(adc_sclk),
	.adc_din(adc_din),
	.adc_dout(adc_dout)

	
);

////// Salidas de datos simulados //////
wire [31:0] datos_simulados;
wire datos_simulados_valid;

///// Salidas de los ADC HS ////////
wire [31:0] data_canal_a;
wire [31:0] data_canal_b;
wire data_adc_valid;

///// Salidas de ADC 2308 ////////
wire [31:0] data_adc_2308;
wire data_adc_2308_valid;


////////////////////////////////////////////////
// ====== Procesamiento de señal  =========
////////////////////////////////////////////////


signal_processing signal_processing_inst(

	.clk(clk_custom),
	.reset_n(reset_n),
	.enable_gral(enable),	
	
	.data_in(datos_simulados),
	.data_in_valid(datos_simulados_valid),
	
	.data_out1(data_procesada1),
	.data_out1_valid(data_procesada1_valid),
	
	.data_out2(data_procesada2),
	.data_out2_valid(data_procesada2_valid),
	
	.ready_to_calculate(ready_to_calculate),
	.processing_finished(calculo_finalizado),
	
	.parameter_in_0(32),
	.parameter_in_1(frames_integracion),
	


);

///// Salidas de procesamiento ////////
wire [63:0] data_procesada1,data_procesada2;
wire data_procesada1_valid,data_procesada2_valid;
wire ready_to_calculate;
wire calculo_finalizado;

////////////////////////////////////////////////
// ====== Contador para ver si clk anda  =========
////////////////////////////////////////////////

reg [31:0] count;
always @ (posedge clk_custom)
begin
	count <= (count == 65000000)? 0 : count+1;
end

assign LED[0] = ( count > (65000000 >> 1) );
	 
	 
	 
endmodule
	 