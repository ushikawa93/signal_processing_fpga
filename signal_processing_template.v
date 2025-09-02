/* ==========================================================================
 * Proyecto : Signal Processing Template (FPGA + HPS)
 * Autor    : Matías Oliva
 * Empresa  : UNLP
 * Descripción :
 *   Módulo principal de un sistema reutilizable de procesamiento de señales
 *   sobre FPGA Intel/Altera (Cyclone V SoC). Este template integra la lógica
 *   de usuario en FPGA con los periféricos básicos y el subsistema HPS.
 *
 * Entradas/Salidas principales:
 *   - Reloj principal de la FPGA (clk)
 *   - Interruptores (SW)
 *   - Botones de usuario (KEY)
 *   - LEDs de usuario (LED)
 *   - Interfaces DDR3, UART, Ethernet, SD, GPIO asociadas al HPS
 *
 * Notas :
 *   - Este archivo define únicamente el módulo top-level (plantilla base).
 *   - Los detalles de procesamiento se agregan en módulos internos.
 *   - Los pines HPS y periféricos están definidos por Quartus/Platform Designer.
 *
 * Dependencias :
 *   - Archivos .qsys y .qsf del proyecto Quartus
 *   - Módulos HDL específicos de procesamiento (añadir según aplicación) 
 *
 *   - Jerarquía:
			signal_processing template
			|	control
			|	|	NIOS 2
			|	|	HPS
			|	data_in
			|	|	embedded_adc (adc23308)
			|	|	data_source (data_simulada)
			|	|	adc_driver (adc_hs)
			|	|	dac_driver (dac_hs)
			|	signal_processing
			|	|	FIR_filter

 *			
 * Fecha : 2025
 * ========================================================================== */


module signal_processing_template(

	////////// CLK /////////
	input clk,	// Entrada de reloj principal de la FPGA
	
	 ///////// SW /////////
    input       [3:0]  SW, // 4 SW de usuario de operacion manual
	
	///////// KEYS ////////
	input 		[1:0] KEY, // 2 botones de usuario activos en bajo
	
	///////// LED /////////	
	output		[3:0] LED,	// 4 LEDS de salida
	
	
	//////// HPS ////////////  // Interfaz DDR3 para comunicacion con HPS (uP)
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
	// Señales para la placa de expansión HS_ADC_DAC (provista por TERASIC)
	 
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
	
	////////  ADC 2308 (SPI) //////
	// Señales para el ADC LTC 2308, disponible en la placa DE1SoC

	output	adc_cs_n,
	output	adc_sclk,
	output	adc_din,
	input 	adc_dout
);

/* ==========================================================================
 *  ======================== Ruteo de Señales =================================
 *
 * Descripción general:
 *   Esta sección define cómo se rutean las señales dentro del sistema.
 *   Permite seleccionar la fuente de datos para cada etapa:
 *     - Etapa de procesamiento
 *     - DAC de salida
 *     - Entradas de memorias FIFO (32 y 64 bits)
 *   Las señales pueden provenir de:
 *     - ADC 2308
 *     - ADC de alta velocidad (adc_hs)
 *     - Datos simulados
 *     - Señales procesadas internamente
 *     - O ninguna (open)
 *
 * Señales principales y configuración:
 *   - fuente_procesamiento: define qué señal se envía a la etapa de cálculo.
 *    - fuente_dac: define qué señal se envía al DAC.
 *     - fuente_fifo0_32bit, fuente_fifo1_32bit, fuente_fifo0_64bit, fuente_fifo1_64bit:
 *       definen qué señales se almacenan en los FIFOs correspondientes.
 *
 * Funcionamiento:
 *   1. Cada fuente seleccionada se rutea a la señal correspondiente mediante 
 *      un bloque combinacional tipo 'case'.
 *   2. Para cada señal se asigna tanto el valor de los datos como la señal de
 *      validez (valid).
 *   3. Los valores posibles para cada fuente son:
 *       - adc_2308
 *        - adc_hs
 *         - simulacion
 *       - procesada_1
 *       - procesada_2
 *       - open (ningún dato)
 *    4. Las señales ruteadas pueden luego ser leídas por la etapa de procesamiento,
 *      enviadas al DAC o almacenadas en los FIFOs para acceso del HPS o NIOS.
 *
 * Observaciones:
 *   - Esta sección facilita cambiar la fuente de datos sin modificar la lógica
 *     interna del procesamiento o los módulos de salida.
 *   - Todos los bloques combinacionales actualizan tanto los datos como la señal
 *     de validez.
 *   - La consistencia entre fuentes y destinos asegura que el sistema funcione
 *     de manera flexible y configurable.
 *
 * ==========================================================================
*/


// Posibilidades...
parameter adc_2308 = 0;
parameter adc_hs = 1;
parameter simulacion = 2;
parameter procesada_1 = 3;
parameter procesada_2 = 4;
parameter open = 5;

// Fuentes de señal para cada etapa del proceso
// Aca se configura fácil que señales van a cada etapa del proceso
// Despues hay una logica combinacional que rutea cada señal adonde tiene que ir

parameter fuente_procesamiento = adc_hs;
parameter fuente_dac = procesada_1 ;

parameter fuente_fifo0_32bit = adc_hs;
parameter fuente_fifo1_32bit = procesada_1;
parameter fuente_fifo0_64bit = procesada_2;
parameter fuente_fifo1_64bit = open;

// Señales para el procesamiento:

reg [31:0] data_in_procesamiento; 
reg data_in_procesamiento_valid; 

always @ (fuente_procesamiento)
begin
	
	case (fuente_procesamiento)
	
		adc_2308:
		begin
			data_in_procesamiento = data_adc_2308;
			data_in_procesamiento_valid = data_adc_2308_valid;
		end
		
		adc_hs:
		begin
			data_in_procesamiento = data_canal_b;
			data_in_procesamiento_valid = data_adc_valid;
		end
		
		simulacion:
		begin
			data_in_procesamiento = datos_simulados;
			data_in_procesamiento_valid = datos_simulados_valid;
		end
				
		open:
		begin
			data_in_procesamiento = 0;
			data_in_procesamiento_valid = 0;
		end
	endcase

end


// Señales para el DAC_HS:

reg [31:0] data_in_dac;
reg data_in_dac_valid;

always @ (fuente_dac)
begin
	
	case (fuente_dac)
	
		adc_2308:
		begin
			data_in_dac = data_adc_2308;
			data_in_dac_valid = data_adc_2308_valid;
		end
		
		adc_hs:
		begin
			data_in_dac = data_canal_b;
			data_in_dac_valid = data_adc_valid;
		end
		
		simulacion:
		begin
			data_in_dac = datos_simulados;
			data_in_dac_valid = datos_simulados_valid;
		end
		
		procesada_1:
		begin
			data_in_dac = data_procesada1;
			data_in_dac_valid = data_procesada1_valid;
		end
		
		procesada_2:
		begin
			data_in_dac = data_procesada2;
			data_in_dac_valid = data_procesada2_valid;
		end
		
		open:
		begin
			data_in_dac = 0;
			data_in_dac_valid = 0;
		end
	endcase

end


// Señales para entradas de memorias FIFO

reg [31:0] data_in_fifo0_32bit,				data_in_fifo1_32bit,				data_in_fifo0_64bit,				data_in_fifo1_64bit;
reg 	   data_in_fifo0_32bit_valid,		data_in_fifo1_32bit_valid,			data_in_fifo0_64bit_valid,			data_in_fifo1_64bit_valid;

always @ (fuente_fifo0_32bit)
begin
	
	case (fuente_fifo0_32bit)
	
		adc_2308:
		begin
			data_in_fifo0_32bit = data_adc_2308;
			data_in_fifo0_32bit_valid = data_adc_2308_valid;
		end
		
		adc_hs:
		begin
			data_in_fifo0_32bit = data_canal_b;
			data_in_fifo0_32bit_valid = data_adc_valid;
		end
		
		simulacion:
		begin
			data_in_fifo0_32bit = datos_simulados;
			data_in_fifo0_32bit_valid = datos_simulados_valid;
		end
		
		procesada_1:
		begin
			data_in_fifo0_32bit = data_procesada1;
			data_in_fifo0_32bit_valid = data_procesada1_valid;
		end
		
		procesada_2:
		begin
			data_in_fifo0_32bit = data_procesada2;
			data_in_fifo0_32bit_valid = data_procesada2_valid;
		end
		
		open:
		begin
			data_in_fifo0_32bit = 0;
			data_in_fifo0_32bit_valid = 0;
		end
	endcase

end


always @ (fuente_fifo1_32bit)
begin
	
	case (fuente_fifo1_32bit)
	
		adc_2308:
		begin
			data_in_fifo1_32bit = data_adc_2308;
			data_in_fifo1_32bit_valid = data_adc_2308_valid;
		end
		
		adc_hs:
		begin
			data_in_fifo1_32bit = data_canal_b;
			data_in_fifo1_32bit_valid = data_adc_valid;
		end
		
		simulacion:
		begin
			data_in_fifo1_32bit = datos_simulados;
			data_in_fifo1_32bit_valid = datos_simulados_valid;
		end
		
		procesada_1:
		begin
			data_in_fifo1_32bit = data_procesada1;
			data_in_fifo1_32bit_valid = data_procesada1_valid;
		end
		
		procesada_2:
		begin
			data_in_fifo1_32bit = data_procesada2;
			data_in_fifo1_32bit_valid = data_procesada2_valid;
		end
					
		open:
		begin
			data_in_fifo1_32bit = 0;
			data_in_fifo1_32bit_valid = 0;
		end
	endcase

end


always @ (fuente_fifo0_64bit)
begin
	
	case (fuente_fifo0_64bit)
	
		adc_2308:
		begin
			data_in_fifo0_64bit = data_adc_2308;
			data_in_fifo0_64bit_valid = data_adc_2308_valid;
		end
		
		adc_hs:
		begin
			data_in_fifo0_64bit = data_canal_b;
			data_in_fifo0_64bit_valid = data_adc_valid;
		end
		
		simulacion:
		begin
			data_in_fifo0_64bit = datos_simulados;
			data_in_fifo0_64bit_valid = datos_simulados_valid;
		end
		
		procesada_1:
		begin
			data_in_fifo0_64bit = data_procesada1;
			data_in_fifo0_64bit_valid = data_procesada1_valid;
		end
		
		procesada_2:
		begin
			data_in_fifo0_64bit = data_procesada2;
			data_in_fifo0_64bit_valid = data_procesada2_valid;
		end
		
		open:
		begin
			data_in_fifo0_64bit = 0;
			data_in_fifo0_64bit_valid = 0;
		end
	endcase

end

always @ (fuente_fifo1_64bit)
begin
	
	case (fuente_fifo1_64bit)
	
		adc_2308:
		begin
			data_in_fifo1_64bit = data_adc_2308;
			data_in_fifo1_64bit_valid = data_adc_2308_valid;
		end
		
		adc_hs:
		begin
			data_in_fifo1_64bit = data_canal_b;
			data_in_fifo1_64bit_valid = data_adc_valid;
		end
		
		simulacion:
		begin
			data_in_fifo1_64bit = datos_simulados;
			data_in_fifo1_64bit_valid = datos_simulados_valid;
		end
		
		procesada_1:
		begin
			data_in_fifo1_64bit = data_procesada1;
			data_in_fifo1_64bit_valid = data_procesada1_valid;
		end
		
		procesada_2:
		begin
			data_in_fifo1_64bit = data_procesada2;
			data_in_fifo1_64bit_valid = data_procesada2_valid;
		end
		
		open:
		begin
			data_in_fifo1_64bit = 0;
			data_in_fifo1_64bit_valid = 0;
		end
	endcase

end

/* =================================================================================
 * ======================== Interfaz de Control ===================================
 *
 * Descripción general:
 *   Esta interfaz conecta la lógica de control basada en NIOS (soft-core) o en el
 *   HPS (Hard Processor System) y la etapa de procesamiento de señales.
 *   Se encarga de:
 *     - Control de habilitación y reset del procesamiento.
 *     - Configuración de parámetros reconfigurables (coeficientes de filtro,
 *       bypass de procesamiento, señales de prueba como LEDs).
 *     - Comunicación de resultados procesados hacia la memoria y otros módulos.
 *
 * Señales principales:
 *   - enable: indica si la etapa de procesamiento puede iniciar cálculos.
 *     Se activa cuando la lógica de control permite y la etapa está lista.
 *   - reset_n: reset activo en bajo, se puede activar desde un botón físico o
 *     desde la lógica de control.
 *   - bypass_processing: permite omitir la etapa de procesamiento, puede
 *     activarse tanto por un switch físico como por la lógica de control.
 *   - filter_coeff[N_filtro]: coeficientes del filtro configurables desde la
 *     interfaz de control.
 *   - led_test: señal de prueba para encender un LED.
 *
 * Descripción de funcionamiento:
 *   1. Habilitación y reset:
 *       enable = enable_from_control && ready_to_calculate
 *       reset_n = !reset_from_control && reset_physical
 *   2. Bypass de procesamiento:
 *       bypass_processing = bypass_physical || bypass_processing_from_control
 *   3. Parámetros reconfigurables:
 *       Se usan para configurar coeficientes del filtro, activar pruebas y
 *       habilitar bypass.
 *   4. Resultados de procesamiento:
 *       Se comunican en formatos de 32 y 64 bits, cada uno con su señal
 *       de validez.
 *   5. Interfaz HPS-DDR3:
 *       Conecta la memoria DDR3 del HPS para almacenar o leer datos
 *       procesados según sea necesario.
 *
 * Observaciones:
 *   - Se permite un reset físico mediante KEY[0].
 *   - Se permite un bypass físico mediante SW[0].
 *   - La interfaz NIOS entrega los parámetros de control, resultados y
 *     flags de procesamiento.
 *   - Todo se organiza para permitir control dinámico desde HPS o NIOS.
 *
 * ================================================================================= */


wire enable;
	assign enable = enable_from_control && ready_to_calculate;
wire reset_n;
	assign reset_n = !reset_from_control && reset_physical;
	
wire enable_from_control;
wire clk_custom;
wire reset_from_control;
wire bypass_processing_from_control;
wire led_test;

wire reset_physical = KEY[0];
wire bypass_physical = SW[0];

wire bypass_processing = bypass_physical || bypass_processing_from_control;

parameter N_filtro = 32;
wire [31:0] filter_coeff [0:N_filtro];

control nios (

	 // Logica de control
	 .clk							(clk),
	 .reset_n					(reset_physical),	
	 .enable						(enable_from_control),
	 .clk_custom				(clk_custom),
	 .reset_from_control		(reset_from_control),
	 .calculo_finalizado 	(calculo_finalizado),
	 
	 // Parametros reconfigurables
	 .parameter_out_0			(filter_coeff[0]),
	 .parameter_out_1			(filter_coeff[1]),
	 .parameter_out_2			(filter_coeff[2]),
	 .parameter_out_3			(filter_coeff[3]),
	 .parameter_out_4			(filter_coeff[4]),
	 .parameter_out_5			(filter_coeff[5]),
	 .parameter_out_6			(filter_coeff[6]),
	 .parameter_out_7			(filter_coeff[7]),
	 .parameter_out_8			(filter_coeff[8]),	 
	 .parameter_out_9			(filter_coeff[9]),
	 
	 .parameter_out_10		(filter_coeff[10]),
	 .parameter_out_11		(filter_coeff[11]),
	 .parameter_out_12		(filter_coeff[12]),
	 .parameter_out_13		(filter_coeff[13]),
	 .parameter_out_14		(filter_coeff[14]),
	 .parameter_out_15		(filter_coeff[15]),
	 .parameter_out_16		(filter_coeff[16]),
	 .parameter_out_17		(filter_coeff[17]),
	 .parameter_out_18		(filter_coeff[18]),	 
	 .parameter_out_19		(filter_coeff[19]),
	 
	 .parameter_out_20		(filter_coeff[20]),
	 .parameter_out_21		(filter_coeff[21]),
	 .parameter_out_22		(filter_coeff[22]),
	 .parameter_out_23		(filter_coeff[23]),
	 .parameter_out_24		(filter_coeff[24]),
	 .parameter_out_25		(filter_coeff[25]),
	 .parameter_out_26		(filter_coeff[26]),
	 .parameter_out_27		(filter_coeff[27]),
	 .parameter_out_28		(filter_coeff[28]),	 
	 .parameter_out_29		(filter_coeff[29]),
	 
	 .parameter_out_30		(filter_coeff[30]),
	 .parameter_out_31		(filter_coeff[31]),
	 .parameter_out_32		(filter_coeff[32]),
	 .parameter_out_33		(bypass_processing_from_control),
	 .parameter_out_34		(led_test),
	
	 // Resultados de procesamiento de 32 bits
	 .result_0_32_bit			(data_in_fifo0_32bit),
	 .result_0_32_bit_valid	(data_in_fifo0_32bit_valid),
	
	 .result_1_32_bit			(data_in_fifo1_32bit),
	 .result_1_32_bit_valid (data_in_fifo1_32bit_valid),
	 
	 .result_0_64_bit			(data_in_fifo0_64bit),
	 .result_0_64_bit_valid	(data_in_fifo0_64bit_valid),
	 
	 .result_1_64_bit			(data_in_fifo1_64bit),
	 .result_1_64_bit_valid	(data_in_fifo1_64bit_valid),

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


/* =================================================================================
 * ===================== Interfaz de Datos de Entrada ==============================
 *  Descripción general:
 *    Este módulo encapsula todas las señales de entrada al sistema, incluyendo
 *    ADCs analógicos de alta velocidad (HS) y ADC 2308, así como señales
 *    digitales simuladas. Proporciona una interfaz unificada para la etapa de
 *    procesamiento y para la salida hacia DACs o FIFOs.
 *
 *  Señales principales:
 *    - reset_n, enable: controlan el inicio y habilitación del muestreo de datos.
 *    - clk_sim, clk_dac, clk_adc, clk_adc_2308: relojes para sincronización de
 *      simulación, DAC y ADCs.
 *    - simulation_data, simulation_data_valid: datos y validez de la simulación
 *      digital.
 *    - data_canal_a, data_canal_b, data_adc_valid: datos y validez de ADC HS.
 *    - data_adc_2308, data_adc_2308_valid: datos y validez de ADC 2308.
 *    - digital_data_in, digital_data_in_valid: datos digitales que se envían
 *      al DAC.
 *    - ADC/DAC HS señales físicas: pines de reloj, datos y control para ADC y DAC
 *      de alta velocidad.
 *    - ADC 2308 señales físicas: pines de chip select, reloj y datos.
 *
 *  Funcionamiento:
 *    1. Dependiendo del ADC seleccionado o de la simulación, el módulo entrega
 *       datos en formato avalon streaming con su señal de validez.
 *    2. La frecuencia de muestreo depende del ADC usado:
 *         - ADC HS: definida por clk_custom.
 *         - ADC 2308: definida por el parámetro f_muestreo_2308 (en Hz).
 *    3. Los datos de entrada se enrutan hacia la etapa de procesamiento o DAC
 *       según la configuración externa.
 *    4. Se soporta sincronización opcional entre ADC y DAC, y selección de
 *       canal para ADC 2308.
 *
 *  Observaciones:
 *    - Los parámetros de configuración podrían ser dinámicos, controlados por
 *      NIOS o HPS si se desea.
 *    - Los datos de simulación permiten probar el sistema sin ADCs.
 *    - Todas las señales críticas están acompañadas de su indicador de validez.
 *    - Esta interfaz unifica señales analógicas, digitales y simuladas para
 *      el procesamiento posterior.
 *
 * ========================================================================== */


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
	.simulation_noise_bits(0),
	.ptos_x_ciclo_sim(32),
	.metodo_ruido(0),
	.ptos_x_ciclo_dac(32),
	.sincronizar_adc_con_dac(0),
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
	
	// Entradas digitales para el DAC
	.digital_data_in(data_in_dac),
	.digital_data_in_valid(data_in_dac_valid),
	
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


/* ================================================================================
 * ======================= Interfaz de Procesamiento de señal =====================
 *  Descripción general:
 *    Módulo de procesamiento de señales que realiza un filtro FIR de orden 32.
 *    Los coeficientes y parámetros se configuran desde la etapa de control.
 *    El procesamiento comienza al activarse la señal 'enable'.
 *
 *  Señales principales:
 *    - clk, reset_n, enable_gral: control de reloj, reset y habilitación.
 *    - bypass: permite omitir el procesamiento.
 *    - data_in, data_in_valid: entrada de datos a procesar.
 *    - data_out1, data_out1_valid, data_out2, data_out2_valid: salidas procesadas.
 *	 - (en este ejemplo data_out2 esta sin conectar a nada)
 *    - ready_to_calculate: indica que el módulo está listo para iniciar.
 *    - processing_finished: indica que el cálculo finalizó.
 *    - parameter_in_0 .. parameter_in_32: coeficientes del filtro FIR.
 *
 *  Observaciones:
 *    - El módulo es configurable dinámicamente mediante los parámetros de control.
 *    - Soporta bypass para pruebas o contingencias.
 * ========================================================================== */


signal_processing signal_processing_inst(

	.clk(clk_custom),
	.reset_n(reset_n),
	.enable_gral(enable),	
	
	.bypass(bypass_processing),
	
	.data_in(data_in_procesamiento),
	.data_in_valid(data_in_procesamiento_valid),
	
	.data_out1(data_procesada1),
	.data_out1_valid(data_procesada1_valid),
	
	.data_out2(data_procesada2),
	.data_out2_valid(data_procesada2_valid),
	
	.ready_to_calculate(ready_to_calculate),
	.processing_finished(calculo_finalizado),
	
	.parameter_in_0(filter_coeff[0]),
	.parameter_in_1(filter_coeff[1]),
	.parameter_in_2(filter_coeff[2]),
	.parameter_in_3(filter_coeff[3]),
	.parameter_in_4(filter_coeff[4]),
	.parameter_in_5(filter_coeff[5]),
	.parameter_in_6(filter_coeff[6]),
	.parameter_in_7(filter_coeff[7]),
	.parameter_in_8(filter_coeff[8]),
	.parameter_in_9(filter_coeff[9]),
	
	.parameter_in_10(filter_coeff[10]),
	.parameter_in_11(filter_coeff[11]),
	.parameter_in_12(filter_coeff[12]),
	.parameter_in_13(filter_coeff[13]),
	.parameter_in_14(filter_coeff[14]),
	.parameter_in_15(filter_coeff[15]),
	.parameter_in_16(filter_coeff[16]),
	.parameter_in_17(filter_coeff[17]),
	.parameter_in_18(filter_coeff[18]),
	.parameter_in_19(filter_coeff[19]),
	
	.parameter_in_20(filter_coeff[20]),
	.parameter_in_21(filter_coeff[21]),
	.parameter_in_22(filter_coeff[22]),
	.parameter_in_23(filter_coeff[23]),
	.parameter_in_24(filter_coeff[24]),
	.parameter_in_25(filter_coeff[25]),
	.parameter_in_26(filter_coeff[26]),
	.parameter_in_27(filter_coeff[27]),
	.parameter_in_28(filter_coeff[28]),
	.parameter_in_29(filter_coeff[29]),
	
	.parameter_in_30(filter_coeff[30]),
	.parameter_in_31(filter_coeff[31]),
	.parameter_in_32(filter_coeff[32]),


);

///// Salidas de procesamiento ////////
wire [63:0] data_procesada1,data_procesada2;
wire data_procesada1_valid,data_procesada2_valid;
wire ready_to_calculate;
wire calculo_finalizado;


/* ================================================================================
 * ======================= Cosas adicionales =====================
 *  Para ver si la placa esta andando y bien configurada se agrega un titileo de LED
 *  También se puede rutear los LED a distintas señales para ver que hacen
 ================================================================================ */


////////////////////////////////////////////////
// ====== Contador para ver si clk anda  =========
////////////////////////////////////////////////

reg [31:0] count;
always @ (posedge clk_custom)
begin
	count <= (count == 65000000)? 0 : count+1;
end

assign LED[0] = ( count > (65000000 >> 1) );


////////////////////////////////////////////////
// ====== Algunos LED para ver cositas  =========
////////////////////////////////////////////////

assign LED[3] = led_test;
	 
endmodule
	 