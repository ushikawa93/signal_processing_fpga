/* ==========================================================================
 * ====================== MEASURE_ZERO_CROSS_OPTIMO =========================
 *  Descripción general:
 *    Este módulo detecta de manera óptima el punto de cruce por cero de una
 *    señal digital cuantizada. Se basa en calcular el valor medio entre el
 *    máximo y mínimo de un ciclo y localizar el dato que más se aproxima a
 *    dicho valor en la pendiente positiva.
 *
 *  Entradas:
 *    - clk: reloj del sistema.
 *    - enable: habilita la medición.
 *    - reset_n: reset asíncrono activo bajo.
 *    - ptos_x_ciclo: cantidad de puntos por ciclo de la señal.
 *    - data: valor de la señal de 14 bits a medir.
 *
 *  Salidas:
 *    - zero_cross: señal que indica cuándo ocurre el cruce por cero.
 *
 *  Funcionamiento:
 *    1. Se calculan max_data y min_data de la señal durante un ciclo completo.
 *    2. Se obtiene middle_data como punto medio entre max y min.
 *    3. Se identifica el dato entrante más cercano a middle_data con pendiente
 *       positiva.
 *    4. Se genera zero_cross cuando la posición coincide con la del dato
 *       más cercano.
 *
 *  Observaciones:
 *    - Ideal para señales periódicas con ruido mínimo.
 *    - El módulo espera que enable esté activo durante todo el ciclo.
 * ========================================================================== */


module measure_zero_cross_optimo(

	input clk,
	input enable,
	input reset_n,
	input [15:0] ptos_x_ciclo,

	input [13:0] data,
	output zero_cross
);


reg [13:0] max_data; initial max_data = 0;
reg [13:0] min_data;	initial min_data = 16383;	// Pongo el maximo valor posible como inicial!
reg [15:0] counter;

wire signed [13:0] middle_data; 
	assign middle_data = min_data + ((max_data - min_data) >> 1);
	
wire mid_data_ready;	assign mid_data_ready = (counter == ptos_x_ciclo);

	
// Algoritmos para calcular max_data y min data
always @ (posedge clk or negedge reset_n)
	if(!reset_n)
	begin
		max_data <= 0;
		min_data <= 16383;
		counter <= 0;
	end
	else if(enable)
	begin
		max_data <= (data > max_data) ? data: max_data;
		min_data <= (data < min_data) ? data: min_data;	
		counter <= (counter == ptos_x_ciclo)? counter : counter + 1; 
	end

// Algoritmo para determinar cual dato entrante se acerca mas a middle_data

wire signed [15:0] data_signed = data;

reg signed [14:0] diff_anterior,minima_diferencia;

wire signed [14:0] diff_actual = ((data_signed - middle_data)>=0)? (data_signed - middle_data): (middle_data-data_signed);

reg [7:0] posicion,posicion_media;
reg posicion_ready;

reg [13:0] data_anterior;
wire positive_slope = (data_anterior < data);

always @ (posedge clk or negedge reset_n)
	if(!reset_n)
	begin
		diff_anterior <= 16382;
		minima_diferencia <= 16382;
		posicion <= 0;
		posicion_media <= 0;
		posicion_ready <= 0;
	end
	else if(mid_data_ready)
	begin
		posicion <= (posicion == ptos_x_ciclo-1)? 0: posicion+1;
		
		diff_anterior <= ((data_signed - middle_data)>=0)? (data_signed - middle_data): (middle_data-data_signed);
			
		if((posicion_ready == 0)&& (diff_actual < diff_anterior) && (diff_actual < minima_diferencia)&&(positive_slope))
		begin
			posicion_media <= posicion;
			minima_diferencia <= diff_actual;
		end
		
		posicion_ready <= (posicion == ptos_x_ciclo-1)? 1 : posicion_ready;	
		
		data_anterior <= data;
	end
	
assign zero_cross = (posicion_ready) && (posicion == posicion_media) ;
	
	
	
endmodule
