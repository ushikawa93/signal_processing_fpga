/* ==========================================================================
 * ======================= DESCOMPONER_EN_DIGITOS ==========================
 *  Descripción general:
 *    Este módulo toma un número de 32 bits y lo descompone en sus dígitos
 *    decimales individuales, útiles para mostrar en displays o para cálculos
 *    BCD.
 *
 *  Entradas:
 *    - numero: valor de 32 bits a descomponer.
 *
 *  Salidas:
 *    - digit0 ... digit5: dígitos decimales correspondientes al número, donde
 *      digit0 es el dígito menos significativo y digit5 el más significativo.
 *
 *  Funcionamiento:
 *    1. Cada dígito se obtiene mediante división y módulo por 10.
 *    2. Permite extraer hasta 6 dígitos de un número entero.
 *
 *  Observaciones:
 *    - Los dígitos resultantes se pueden usar directamente para displays BCD
 *      o para interfaces de usuario.
 * ========================================================================== */


module descomponer_en_digitos(
	input [31:0] numero,
	output [4:0] digit0,
	output [4:0] digit1,
	output [4:0] digit2,
	output [4:0] digit3,
	output [4:0] digit4,
	output [4:0] digit5
	
);

assign digit0 = numero % 10;
assign digit1 = (numero/10) % 10;
assign digit2 = (numero/100) % 10;
assign digit3 = (numero/1000) % 10;
assign digit4 = (numero/10000) % 10;
assign digit5 = (numero/100000) % 10;

endmodule


