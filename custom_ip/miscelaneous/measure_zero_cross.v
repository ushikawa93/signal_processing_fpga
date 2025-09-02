/* ==========================================================================
 * ========================= MEASURE_ZERO_CROSS =============================
 *  Descripción general:
 *    Este módulo detecta el cruce por cero aproximado de una señal digital
 *    cuantizada. Se basa en calcular el valor medio entre el máximo y mínimo
 *    de la señal y usar un margen para determinar cuándo la señal cruza
 *    dicho valor con pendiente positiva.
 *
 *  Entradas:
 *    - clk: reloj del sistema.
 *    - enable: habilita la medición.
 *    - reset_n: reset asíncrono activo bajo.
 *    - ptos_x_ciclo: cantidad de puntos por ciclo de la señal.
 *    - data: valor de la señal de 14 bits a medir.
 *
 *  Salidas:
 *    - zero_cross: indica cuándo ocurre el cruce por cero aproximado.
 *
 *  Funcionamiento:
 *    1. Se calcula max_data y min_data mientras enable está activo.
 *    2. Se obtiene middle_data como promedio entre max_data y min_data.
 *    3. Se compara la señal con middle_data usando un margen definido.
 *    4. Se activa zero_cross solo si la señal cruza middle_data con pendiente
 *       positiva y el contador indica que se completó un ciclo.
 *
 *  Observaciones:
 *    - El margen permite tolerancia frente a ruido en la señal.
 *    - Si no se detecta cruce tras un ciclo completo, los registros se
 *      reinician automáticamente.
 * ========================================================================== */


module measure_zero_cross(
input clk,
input enable,
input reset_n,
input [15:0] ptos_x_ciclo,

input [13:0] data,
output zero_cross
);

wire [7:0] margin = 20;

reg [13:0] max_data; initial max_data = 0;
reg [13:0] min_data;	initial min_data = 16383;	// Pongo el maximo valor posible como inicial!
reg [15:0] counter;
reg [13:0] previous_data;
reg positive_slope;
reg andando;

wire ready;	assign ready = (counter > ptos_x_ciclo);

wire [13:0] middle_data; 
	assign middle_data = min_data + ((max_data - min_data) >> 1);
	
assign zero_cross = (((data - middle_data)<margin)||((middle_data - data)<margin)) && (enable) && (ready) && (positive_slope);


// Algoritmos para calcular max_data y min data
always @ (posedge clk or negedge reset_n)
	if(!reset_n)
	begin
		max_data <= 0;
		min_data <= 16383;
		counter <= 0;
		andando <= 0; 
	end
	else if(enable)
	begin
		max_data <= (data > max_data) ? data: max_data;
		min_data <= (data < min_data) ? data: min_data;	
		counter <= (counter == 2048)? counter : counter + 1; 
		
		previous_data <= data;
		positive_slope <= (previous_data < data);
		
		// Si despues de un buen rato la cosa no arranca reinicio todo...
		if(zero_cross) andando <= 1; 
		
		if( (counter == 2047) && (!andando) )
		begin
			max_data <= 0;
			min_data <= 16383;
			counter <= 0;		
			andando <= 0; 
		end
		
	end
	

endmodule
