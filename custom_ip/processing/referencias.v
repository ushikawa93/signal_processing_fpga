/* ==========================================================================
 * ============================== REFERENCIAS ==============================
 *  Descripción general:
 *    Este módulo genera referencias seno y coseno discretizadas, almacenadas
 *    en tablas ROM, para ser utilizadas en la multiplicación coherente en un
 *    Lock-In digital.
 *
 *  Entradas:
 *    - clock: reloj del sistema.
 *    - reset_n: reset activo en bajo.
 *    - enable: habilita el procesamiento.
 *    - pts_x_ciclo: cantidad de puntos por ciclo de la referencia (configurable).
 *    - avanzar_en_tabla: habilita el avance del índice de la tabla en cada ciclo.
 *
 *  Salidas:
 *    - data_out_seno: valor de la referencia seno correspondiente al índice actual.
 *    - data_out_cos: valor de la referencia coseno correspondiente al índice actual.
 *
 *  Funcionamiento:
 *    1. Se calcula el intervalo de acceso a la tabla según `pts_x_ciclo`.
 *    2. La señal `avanzar_en_tabla` avanza el índice de la tabla.
 *    3. Se calcula `index_out = index * interval` para obtener el valor correcto
 *       en la tabla ROM de 2048 posiciones.
 *    4. Se ajusta el valor restando `ref_mean_value` para centrar en cero.
 *
 *  Observaciones:
 *    - Las tablas ROM deben contener valores de 16 bits de seno y coseno.
 *    - Este módulo asegura que la referencia se sincroniza con la señal de entrada
 *      para el procesamiento Lock-In.
 * ========================================================================== */


module referencias(

	// Entradas de control
	input clock,
	input reset_n,
	input enable,
	
	// Parametro configurable
	input [31:0] pts_x_ciclo,

	// Entrada de sincronizacion
	input avanzar_en_tabla,
	
	output reg signed [31:0] data_out_seno,
	output reg signed [31:0] data_out_cos

);


//=======================================================
// Parametros de configuracion de los módulos
//=======================================================

parameter ref_mean_value = 32767;
wire [15:0] M = pts_x_ciclo;				// Puntos por ciclo de señal


reg [15:0] interval;
	always @ (posedge clock) interval = 2048/M; // Para poder cambiar el largo de la secuencia sin tener que leer otro archivo
	

//=======================================================
// Reg/Wire declarations
//=======================================================

// Referencias seno y coseno en sendas LU table
reg [15:0]  ref_sen   [0:2047];	initial	$readmemh("LU_Tables/x2048_16b.mem",ref_sen);
reg [15:0] 	ref_cos   [0:2047];	initial	$readmemh("LU_Tables/y2048_16b.mem",ref_cos);

reg [31:0] index,index_out;



//=======================================================
// Algoritmo principal
//=======================================================

always @ (posedge clock or negedge reset_n)
begin
	
	if(!reset_n)
	begin		
		
		index <= 1;	
		index_out <= 0;	
		
	end
	else if(enable)
	begin
		if(avanzar_en_tabla)
		begin
			
			index <= (index == (M-1))? 0: index+1;					
			index_out <= index*interval;	
			
			data_out_seno <= ref_sen[index_out] - ref_mean_value;
			data_out_cos <= ref_cos[index_out] - ref_mean_value;
				
		end
	end
end

//=======================================================
// Salidas
//=======================================================
	



endmodule


