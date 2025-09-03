/* ==========================================================================
 * ============================ conduitToReset ===============================
 * Esto es simplemente un flip-flop D. Sirve para adaptar lógica en el QSYS
 * ========================================================================== */
 
module conduitToReset(
	input clock,
	input coe_entrada,
	output reg RESET
);

always @ (posedge clock)
begin
	RESET = coe_entrada;
end
	
endmodule

