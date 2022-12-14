module adc_dac_driver(

	// Entradas de control
	input 			 CLK_65,
	input				 CLK_125,
	input				 reset_n,
	input				 enable,
	
	// Parametros de configuracion
	input [15:0]	 ptos_x_ciclo,
	input 			 seleccion_dac,		// 0 -> seno / 1 -> constante

	// Entradas y salidas de ADC/DAC
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
	
	// Interfaz avalon streaming de salida
	output	[13:0] data_canal_a,
	output	[13:0] data_canal_b,
	output			 data_valid,
	
	// Salida extra para ver en osciloscopio	
	output			 data_valid_dac_export
	
);


//=======================================================
// Origen de los datos para el dac (LU table) 
//=======================================================


wire data_valid_dac;
wire [13:0] dato_dac;
wire zero_cross;


data_source_dac data_s (

	.clock(CLK_65),
	.reset_n(reset_n),
	.CE(enable),
	
	.ptos_x_ciclo(ptos_x_ciclo),
	.seleccion_dac(seleccion_dac),
	
	.zero_cross(zero_cross),
	.data_valid(data_valid_dac),
	.data(dato_dac)
	
);


//=======================================================
//  ADC y DAC REG/WIRE declarations
//=======================================================

parameter nivel_idle = 8192;			// Cuando los DAC estan inactivos los pongo a este valor
												// esto es para que cuando arranque la cosa no tenga que hacer un salto muy grande...
												// si los pongo en 0 cuando arranca tiene que saltar al 8192, y no le da el slew rate a los OPA


assign  DAC_WRT_B = CLK_65;       //Input write signal for PORT B
assign  DAC_WRT_A = CLK_65;       //Input write signal for PORT A

assign  DAC_MODE = 1; 		        //Mode Select. 1 = dual port, 0 = interleaved.

assign  DAC_CLK_B = CLK_65; 	    //PLL Clock to DAC_B
assign  DAC_CLK_A = CLK_65; 	    //PLL Clock to DAC_A
 
assign  ADC_CLK_B = CLK_65;  	    //PLL Clock to ADC_B
assign  ADC_CLK_A = CLK_65;  	    //PLL Clock to ADC_A

assign  ADC_OEB_A = 0; 		  	    //ADC_OEA	Output enables activos en bajo
assign  ADC_OEB_B = 0; 			    //ADC_OEB

assign  POWER_ON  = 1;            //Disable OSC_SMA

assign  DAC_DA = (data_valid_dac)? dato_dac : nivel_idle ; 
assign  DAC_DB = (data_valid_dac)? dato_dac : nivel_idle ; 

reg	[13:0]	r_ADC_DA;
reg	[13:0]	r_ADC_DB;

always @ (posedge CLK_65) r_ADC_DA <= ADC_DA;
always @ (posedge CLK_65) r_ADC_DB <= ADC_DB;


//=======================================================
//  Circuiteria del data_valid
//=======================================================

wire data_valid_adc;

//Desde el data_valid del source necesito 1 ciclo para que se acomode el DAC, y
//el ADC necesita un rato para acomodarse (En total hay "delay" ciclos de reloj con cosas que no tienen sentido)


parameter delay = 11;
reg [15:0] counter_pipeline;

always @ (posedge CLK_65)
	if(!reset_n)
		counter_pipeline <= 0;
	else if(data_valid_dac)
		counter_pipeline <= (counter_pipeline == delay)? counter_pipeline : counter_pipeline + 1;


assign data_valid_adc = (data_valid_dac && (counter_pipeline == delay));

//=======================================================
//  Salidas
//=======================================================

assign data_canal_a =  r_ADC_DA;
assign data_canal_b =  r_ADC_DB;
assign data_valid = data_valid_adc;
assign data_valid_dac_export = data_valid_dac;


endmodule

