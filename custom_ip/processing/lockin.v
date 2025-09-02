/* ==========================================================================
 * ============================== LOCKIN ====================================
 *  Descripción general:
 *    Este módulo implementa un Lock-in amplifier digital simple para una
 *    señal de entrada en streaming. Calcula las componentes en fase y
 *    cuadratura mediante multiplicación por referencias seno y coseno
 *    almacenadas en ROM, y un esquema de acumulación tipo FIFO circular.
 *
 *  Entradas:
 *    - clock: reloj del sistema.
 *    - reset: reset síncrono.
 *    - CE: enable de entrada para procesar el dato.
 *    - data: señal de entrada (signed 32 bits).
 *
 *  Salidas:
 *    - data_out_fase: componente en fase acumulada (signed 32 bits).
 *    - data_valid_fase: indica que data_out_fase es válida.
 *    - data_out_cuad: componente en cuadratura acumulada (signed 32 bits).
 *    - data_valid_cuad: indica que data_out_cuad es válida.
 *
 *  Funcionamiento:
 *    1. La señal de entrada se multiplica por la referencia seno y coseno
 *       correspondiente según el índice de la tabla de ROM.
 *    2. Los productos se almacenan en RAM de puerto simple para poder restar
 *       la contribución anterior y sumar la nueva, implementando un filtro
 *       pasabajo tipo moving average de largo M+1.
 *    3. La salida de fase y cuadratura se actualiza en cada ciclo válido.
 *    4. El índice de la tabla de referencia se incrementa de manera circular.
 *
 *  Observaciones:
 *    - Se utiliza un FSM con 6 estados para pipeline: init, esperar,
 *      multiplicar, restar_anterior, sumar_nuevo y act_salida.
 *    - Las tablas de referencia se cargan mediante $readmemh desde ROM.
 *    - Este módulo es adecuado para longitudes de ventana fijas y relativamente
 *      pequeñas (M=31 por defecto).
 * ========================================================================== */


module lockin(

	input clock,
	input reset,
	input CE,
	input signed [31:0] data,
	
	output reg signed [31:0] data_out_fase,
	output reg data_valid_fase,
	
	output reg signed [31:0] data_out_cuad,
	output reg data_valid_cuad
	
);

parameter M=31; 

reg [2:0] state; parameter init=0, esperar=1, multiplicar=2,restar_anterior=3,sumar_nuevo=4, act_salida=5; initial state=init;

reg signed [63:0] acum_fase;	// Son un poco mas largos para que no haya overflow
reg signed [63:0] acum_cuad;

// Esto es para inferir la tabla en la que voy guardando los productos con una ram (mas rapido asi)
single_port_ram ram_fase(
	.data(prod_fase),
	.addr(index),
	.we(write_rams_en),
	.clk(clock),
	.q(dato_actual_fase)
);

single_port_ram ram_cuad(
	.data(prod_cuad),
	.addr(index),
	.we(write_rams_en),
	.clk(clock),
	.q(dato_actual_cuad)
);

//reg write_rams_en; initial write_rams_en=0;
wire write_rams_en; assign write_rams_en = (state == multiplicar)? 1:0;
wire signed [31:0] dato_actual_fase,dato_actual_cuad;

// Estos dos los implementa bien como roms asi como estan...
reg [15:0]  ref_sen   [0:M];	initial	$readmemh("LU_tables/x32_16b.mem",ref_sen);
reg [15:0] 	ref_cos   [0:M];	initial	$readmemh("LU_tables/y32_16b.mem",ref_cos);
 
reg [5:0] index;

reg signed [31:0] data_reg;
	
reg signed [31:0] prod_fase; //assign prod_fase = data_reg * ref_fase_actual;
reg signed [31:0] prod_cuad; //assign prod_cuad = data_reg * ref_cuad_actual;

reg signed [31:0] aux_reg_fase;
reg signed [31:0] aux_reg_cuad;

reg signed [31:0] ref_fase_actual;	//assign ref_fase_actual = ref_sen[index]-32768;
reg signed [31:0] ref_cuad_actual; //assign ref_cuad_actual = ref_cos[index]-32768;
 
	
always @ (posedge clock)
begin

	if(reset)
		state <= init;

	case (state)
		init:
		begin
		
			acum_fase<=0;
			acum_cuad<=0;
			index <= 0;
			data_reg <= 0;
						
			state <= esperar;
		end
			
		esperar:
		begin
			data_valid_fase <= 0;
			data_valid_cuad <= 0;		
								
			if(CE) 
			begin
			
				ref_fase_actual <= ref_sen[index]-32768;
				ref_cuad_actual <= ref_cos[index]-32768;
			
				data_reg <= data;						
				state <= multiplicar;				
			end		
			
		end		
				
		multiplicar:
		begin					

			prod_fase <= data_reg * ref_fase_actual;
			prod_cuad <= data_reg * ref_cuad_actual;
			
			aux_reg_fase <= dato_actual_fase;
			aux_reg_cuad <= dato_actual_cuad;
				
			state <= restar_anterior;			
		
		end
		
		restar_anterior:
		begin		

			acum_fase <= acum_fase - aux_reg_fase;				
			acum_cuad <= acum_cuad - aux_reg_cuad;
			
			state <= sumar_nuevo;	
		
		end
		
		sumar_nuevo:
		begin
			acum_fase <= acum_fase + dato_actual_fase;
			acum_cuad <= acum_cuad + dato_actual_cuad;
			
			state <= act_salida;
		end
		
		act_salida:
		begin 							
		
			data_out_fase <= acum_fase >> 5;
			data_valid_fase <= 1;
			
			data_out_cuad <= acum_cuad >> 5;
			data_valid_cuad <= 1;
			
			index <= (index== M)? 0: index+1;
							
			state <= esperar;		
		end
		
	endcase	
	
end

endmodule

	
	
	
	