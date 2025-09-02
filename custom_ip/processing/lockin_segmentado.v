/* ==========================================================================
 * ========================= LOCKIN_SEGMENTADO ==============================
 *  Descripción general:
 *    Este módulo implementa un Lock-in amplifier digital de manera segmentada,
 *    separando la multiplicación por referencias y los filtros pasabajos de
 *    fase y cuadratura en módulos independientes. Permite el cálculo de la
 *    componente en fase y cuadratura de una señal de entrada en streaming.
 *
 *  Entradas:
 *    - clock: reloj del sistema.
 *    - reset: reset síncrono.
 *    - enable: habilita el procesamiento.
 *    - ptos_x_ciclo: cantidad de puntos por ciclo de la señal.
 *    - frames_integracion: cantidad de ciclos a promediar.
 *    - data_valid: indica que el dato de entrada es válido.
 *    - data: señal de entrada (signed 32 bits).
 *
 *  Salidas:
 *    - data_out_fase: componente en fase acumulada (signed 64 bits).
 *    - data_valid_fase: indica que data_out_fase es válida.
 *    - data_out_cuad: componente en cuadratura acumulada (signed 64 bits).
 *    - data_valid_cuad: indica que data_out_cuad es válida.
 *    - lockin_ready: indica que ambos canales del Lock-in están listos.
 *    - fifos_llenos: indica que los FIFOs internos de fase y cuadratura están completos.
 *
 *  Funcionamiento:
 *    1. Los datos de entrada se multiplican por las referencias seno y coseno 
 *       correspondientes mediante el módulo `multiplicate_ref`.
 *    2. Los resultados se envían a filtros pasabajos (IIR) independientes para
 *       fase y cuadratura usando `multiple_IIR`.
 *    3. Las salidas de fase y cuadratura se actualizan en streaming.
 *    4. Las señales `lockin_ready` y `fifos_llenos` se generan combinando el
 *       estado de los dos filtros.
 *
 *  Observaciones:
 *    - Este enfoque segmentado permite reutilizar los módulos de multiplicación
 *      y filtrado y facilita el pipeline y la inferencia de bloques DSP.
 *    - La sincronización de las señales de validación se realiza con registros
 *      para asegurar consistencia en todo el pipeline.
 * ========================================================================== */


module lockin_segmentado(

	// Entradas de control
	input clock,
	input reset,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	input [15:0] frames_integracion,
	
	// Entrada avalon streaming
	input data_valid,
	input signed [31:0] data,	
		
	// Salidas avalon streaming fase y cuadratura
	output signed [63:0] data_out_fase,
	output data_valid_fase,
	
	output signed [63:0] data_out_cuad,
	output data_valid_cuad,
	
	// Salidas auxiliares
	output reg lockin_ready,	
	output reg fifos_llenos
	
);


//=======================================================
// Multiplicacion por referencia
//=======================================================

multiplicate_ref multiplicador(

	.clock(clock),
	.reset(reset),
	.enable(enable),
	
	.ptos_x_ciclo(ptos_x_ciclo),
	
	.data(data),
	.data_valid(data_valid),		
		
	.data_out_seno(data_out_seno),
	.data_out_coseno(data_out_coseno),
	.data_valid_multiplicacion(data_valid_multiplicacion),	

);


wire signed [63:0] data_out_seno;			
wire signed [63:0] data_out_coseno;
wire data_valid_multiplicacion;


//=======================================================
// Filtros pasabajos
//=======================================================

multiple_IIR filtro_fase(

	// Entradas de control
	.clock(clock),
	.reset(reset),
	.enable(enable),
	
	// Parametros configurables (Para IIR no tienen funcionalidad)
	.ptos_x_ciclo(ptos_x_ciclo),
	.frames_integracion(frames_integracion),
	
	// Interfaz avalon streaming de entrada
	.data_valid(data_valid_multiplicacion),
	.data(data_out_seno),	
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_fase),
	.data_out_valid(data_valid_fase),		
	
	// Salidas auxiliares
	.ready(lockin_fase_ready),
	.fifo_lleno(fifo_lleno_fase)

);

wire fifo_lleno_fase,lockin_fase_ready;


multiple_IIR filtro_cuadratura(

	// Entradas de control
	.clock(clock),
	.reset(reset),
	.enable(enable),
	
	// Parametros configurables (Para IIR no tienen funcionalidad)
	.ptos_x_ciclo(ptos_x_ciclo),
	.frames_integracion(frames_integracion),
	
	// Interfaz avalon streaming de entrada
	.data_valid(data_valid_multiplicacion),
	.data(data_out_coseno),	
	
	// Interfaz avalon streaming de salida
	.data_out(data_out_cuad),
	.data_out_valid(data_valid_cuad),
	
	// Salidas auxiliares
	.ready(lockin_cuadratura_ready),
	.fifo_lleno(fifo_lleno_cuad)

);

wire fifo_lleno_cuad,lockin_cuadratura_ready;

always @ (posedge clock) fifos_llenos <= (fifo_lleno_fase && fifo_lleno_cuad);
always @ (posedge clock) lockin_ready <= (lockin_fase_ready && lockin_cuadratura_ready);




endmodule

