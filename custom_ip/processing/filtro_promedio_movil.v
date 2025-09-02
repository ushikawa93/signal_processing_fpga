/* ==========================================================================
 * ======================= FILTRO PROMEDIO MÓVIL ===========================
 *  Descripción general:
 *    Este módulo implementa un filtro promedio móvil sobre datos de entrada
 *    en streaming. Mantiene un buffer circular de tamaño configurable y
 *    calcula un promedio acumulado sobre M puntos por N frames de integración.
 *    La salida representa el promedio actualizado en cada ciclo.
 *
 *  Entradas:
 *    - clock: reloj del sistema.
 *    - reset_n: reset activo en bajo.
 *    - enable: habilita el procesamiento de datos.
 *    - ptos_x_ciclo: número de puntos por ciclo de señal.
 *    - frames_integracion: cantidad de frames a integrar.
 *    - data_valid: indica que el dato de entrada es válido.
 *    - data: dato de entrada (signed 64 bits).
 *
 *  Salidas:
 *    - data_out: promedio calculado (signed 64 bits).
 *    - data_out_valid: indica que la salida es válida.
 *    - ready_to_calculate: indica que el filtro está listo para calcular.
 *    - fifo_lleno: indica que el buffer circular está completo.
 *
 *  Funcionamiento:
 *    1. Los datos entrantes se almacenan en un buffer circular.
 *    2. Un acumulador mantiene la suma de los últimos M*N datos.
 *    3. Para cada nuevo dato, se suma al acumulador y se resta el dato que
 *       se sobrescribe en el buffer, generando el promedio móvil.
 *    4. Se generan señales de validación para sincronizar con etapas posteriores.
 *
 *  Observaciones:
 *    - El tamaño del buffer está parametrizado por buf_tam.
 *    - Permite integración de señal periódica mediante frames y puntos por ciclo.
 * ========================================================================== */


module filtro_promedio_movil(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametros de configuracion
	input [15:0] ptos_x_ciclo,
	input [15:0] frames_integracion,
	
	// Entrada avalon streaming 
	input data_valid,
	input signed [63:0] data,	
		
	// Salida avalon streaming
	output reg signed [63:0] data_out,
	output reg data_out_valid,

	// Salidas auxiliares
	output ready_to_calculate,
	output reg fifo_lleno

);

//=======================================================
// Parametros de configuracion 
//=======================================================

parameter buf_tam = 4096;					// Con 8192 ya me paso de la cantidad de bloques de ram que hay
parameter delay=3;
parameter fifo_depth = 2048;

parameter M = 32;
parameter N = 32;

/*

wire [15:0] M;	assign M = ptos_x_ciclo;				// Puntos por ciclo de señal
wire [7:0] N; 	assign N = frames_integracion;		// Frames de integracion // Largo del lockin M*N	

*/

//=======================================================
// Reg/Wire declarations
//=======================================================

reg signed [63:0] data_in_2_etapa;
reg signed [63:0] data_out_2_etapa;

reg signed [63:0] acumulador;	// Son un poco mas largos para que no haya overflow

reg signed [63:0] array_datos [0:buf_tam-1];

reg data_valid_1,data_valid_2, limpiando_arrays;

reg [15:0] i,index_promediacion, ciclos_completados;

reg [15:0] ciclos_para_llenar_fifo;
	always @ (posedge clock) ciclos_para_llenar_fifo <= 2048 / (MxN);
	
reg [15:0] MxN;
	always @ (posedge clock) MxN <= M*N;


// Registro las entradas... es mas prolijo trabajar con las entradas registradas
reg signed [63:0] data_in_reg; always @ (posedge clock) data_in_reg <= (!reset_n)? 0: data;
reg data_valid_reg; always @ (posedge clock) data_valid_reg <= (!reset_n)? 0: data_valid;

//=======================================================
// Algoritmo principal
//=======================================================

always @ (posedge clock or negedge reset_n)
begin

	if(!reset_n)
	begin
	
		acumulador<=0;
		ciclos_completados<=0;
				
		data_in_2_etapa<=0;		
		data_out_2_etapa<=0;
		index_promediacion <= 0;
		
		fifo_lleno<=0;	
		i <= 0;
		data_valid_1<=0;
		data_valid_2<=0;
		limpiando_arrays<=1;
		
	end	
	
	else if (enable)
	begin
		
		if(data_valid_reg && !fifo_lleno)
		begin
		
			index_promediacion <=  (index_promediacion == ((MxN)-1))? 0 : index_promediacion + 1;
			ciclos_completados <= (index_promediacion == ((MxN)-1))? ciclos_completados+1: ciclos_completados;
			fifo_lleno <= (ciclos_completados == ciclos_para_llenar_fifo)? 1:0;

			//guardar dato en arreglo (1 etapa)
							
			array_datos[index_promediacion] <= data_in_reg;		
			data_in_2_etapa <= data_in_reg;			
			data_out_2_etapa <= array_datos[index_promediacion];		
			data_valid_1 <= 1;
				
			// Actualizar acumulador (2 etapa)				
			acumulador <= acumulador + data_in_2_etapa - data_out_2_etapa;		
			data_valid_2 <= data_valid_1;
			
					
			// Actualizar salida (3 etapa)		
			data_out <= acumulador;			
			
		end
	end	
	
	else
	begin		
      if(i<buf_tam-1)
		begin		
			array_datos[i]<=0;
			i<=i+1;			
		end
		else
			limpiando_arrays <= 0;	
	end
	
end

always @ (posedge clock) 
	data_out_valid <= (data_valid_2 && data_valid_reg);

	
assign ready_to_calculate = !limpiando_arrays;

endmodule
