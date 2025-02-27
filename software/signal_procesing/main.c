/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "funciones_pll.h"
#include "parameters_control.h"
#include "system.h"
#include "control_functions.h"
#include "result_functions.h"
#include "lockin_results.h"

void imprimir_buffer_32bit(int N_datos,int* puntero_a_buffer);
void imprimir_buffer_64bit(int N_datos,long long* puntero_a_buffer);
void setCoeff(int* filtro);

// Punteros a posiciones de memoria que me interesan
int* pll_ptr = (int*)PLL_RECONFIGURAR_BASE;
int* clk_divider_ptr = (int*)DIVISOR_CLOCK_BASE;
int* parameters_ptr = (int*)PARAMETERS_BASE;
int* parameters_1_ptr = (int*)PARAMETERS_1_BASE;
int* parameters_2_ptr = (int*)PARAMETERS_2_BASE;
int* parameters_3_ptr = (int*)PARAMETERS_3_BASE;

int* enable_ptr = (int*)ENABLE_BASE;
int* reset_ptr = (int*) RESET_BASE;
int* finish_ptr = (int*) FINALIZACION_BASE;

int* fifo0_32_bit_ptr = (int*)FIFO0_32_BIT_BASE;
int* result0_32_bit = (int*)RESULT0_32_BIT_BASE;

int* fifo1_32_bit_ptr = (int*)FIFO1_32_BIT_BASE;
int* result1_32_bit = (int*)RESULT1_32_BIT_BASE;

unsigned int* fifo0_64_bit_down_ptr = (unsigned int*)FIFO0_64_BIT_DOWN_BASE;
unsigned int* fifo0_64_bit_up_ptr = (unsigned int*)FIFO0_64_BIT_UP_BASE;
unsigned int* result0_64_bit_down = (unsigned int*)RESULT0_64_BIT_DOWN_BASE;
unsigned int* result0_64_bit_up = (unsigned int*)RESULT0_64_BIT_UP_BASE;

unsigned int* fifo1_64_bit_down_ptr = (unsigned int*)FIFO1_64_BIT_DOWN_BASE;
unsigned int* fifo1_64_bit_up_ptr = (unsigned int*)FIFO1_64_BIT_UP_BASE;
unsigned int* result1_64_bit_down = (unsigned int*)RESULT1_64_BIT_DOWN_BASE;
unsigned int* result1_64_bit_up = (unsigned int*)RESULT1_64_BIT_UP_BASE;

int main()
{
	// Filtros Pasa-bajos
	int PB_0_05 [33] = {83,	118,	188,	306,	482,	724,	1031,	1400,	1820,	2272,	2737,	3189,	3604,	3957,	4227,	4395,	4453,	4395,	4227,	3957,	3604,	3189,	2737,	2272,	1820,	1400,	1031,	724,	482,	306,	188,	118,	83};
	int PB_0_1 [33] = {-101,	-125,	-165,	-207,	-222,	-169,	0,	325,	835,	1533,	2391,	3352,	4334,	5241,	5975,	6453,	6619,	6453,	5975,	5241,	4334,	3352,	2391,	1533,	835,	325,	0,	-169,	-222,	-207,	-165,	-125,	-101};
	int PB_0_15 [33] = {98,	87,	52,	-40,	-219,	-480,	-757,	-927,	-825,	-293,	766,	2339,	4277,	6314,	8115,	9355,	9797,	9355,	8115,	6314,	4277,	2339,	766,	-293,	-825,	-927,	-757,	-480,	-219,	-40,	52,	87,	98};
	int PB_0_2 [33] = {-62,	0,	100,	240,	354,	316,	-1,	-614,	-1339,	-1785,	-1463,	0,	2651,	6097,	9567,	12147,	13100,	12147,	9567,	6097,	2651,	0,	-1463,	-1785,	-1339,	-614,	-1,	316,	354,	240,	100,	0,	-62};
	int PB_0_25 [33] = { -1,	-88,	-172,	-180,	0,	382,	761,	739,	-1,	-1331,	-2496,	-2353,	0,	4546,	10088,	14654,	16422,	14654,	10088,	4546,	0,	-2353,	-2496,	-1331,	-1,	739,	761,	382,	0,	-180,	-172,	-88,	-1};
	int PB_0_3 [33] = {61,	123,	100,	-78,	-355,	-436,	-1,	842,	1335,	578,	-1460,	-3311,	-2646,	1976,	9546,	16682,	19607,	16682,	9546,	1976,	-2646,	-3311,	-1460,	578,	1335,	842,	-1,	-436,	-355,	-78,	100,	123,	61};

	// Filtros Pasa-altos
	int PA_0_05 [33] = {-62,	-88,	-139,	-226,	-356,	-534,	-760,	-1032,	-1341,	-1674,	-2016,	-2349,	-2655,	-2915,	-3113,	-3238,	62309,	-3238,	-3113,	-2915,	-2655,	-2349,	-2016,	-1674,	-1341,	-1032,	-760,	-534,	-356,	-226,	-139,	-88,	-62};
	int PA_0_1 [33] = {99,	123,	162,	204,	219,	166,	-1,	-323,	-827,	-1517,	-2365,	-3315,	-4286,	-5183,	-5908,	-6381,	58900,	-6381,	-5908,	-5183,	-4286,	-3315,	-2365,	-1517,	-827,	-323,	-1,	166,	219,	204,	162,	123,	99};
	int PA_0_15 [33] = {-100,	-88,	-54,	39,	219,	481,	760,	931,	828,	294,	-771,	-2351,	-4299,	-6346,	-8156,	-9402,	55793,	-9402,	-8156,	-6346,	-4299,	-2351,	-771,	294,	828,	931,	760,	481,	219,	39,	-54,	-88,	-100};
	int PA_0_2 [33] = {61,	0,	-101,	-241,	-355,	-317,	-1,	612,	1337,	1782,	1461,	0,	-2649,	-6093,	-9561,	-12138,	52360,	-12138,	-9561,	-6093,	-2649,	0,	1461,	1782,	1337,	612,	-1,	-317,	-355,	-241,	-101,	0,	61};
	int PA_0_25 [33] = {-1,	87,	171,	178,	-1,	-382,	-760,	-739,	-1,	1327,	2491,	2348,	-1,	-4539,	-10072,	-14630,	49182,	-14630,	-10072,	-4539,	-1,	2348,	2491,	1327,	-1,	-739,	-760,	-382,	-1,	178,	171,	87,	-1};
	int PA_0_3 [33] = {-62,	-124,	-101,	78,	355,	436,	0,	-845,	-1340,	-581,	1463,	3320,	2653,	-1983,	-9576,	-16733,	45888,	-16733,	-9576,	-1983,	2653,	3320,	1463,	-581,	-1340,	-845,	0,	436,	355,	78,	-101,	-124,	-62};

    int Bypass_filter [33] = { 65536, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };


	int f	= 1;	//En MHZ
	int div = 1; // Si queremos f_muestreo menor a 1MHz
	int imprimir = 1;

	configurar_pll(f,pll_ptr);
	setClockDivider(div ,clk_divider_ptr);

	int * filtro_usado = PB_0_05;
	int indice_filtro = 2;

	float f_muestreo = f*1000000/div;

	setCoeff(filtro_usado);
	setParam(3,0,parameters_3_ptr);
	setParam(4,1,parameters_3_ptr);

	printf("Usted esta usando un filtro pasa-altos \n" );
	printf("Frecuencia de corte actual: %f", 0.05 * indice_filtro * f_muestreo / 2 );

	Reset(enable_ptr,reset_ptr);
	setEnable(enable_ptr);
	waitForFin(finish_ptr);

	if (imprimir == 1){
		printf("\n\nResultados FIFO 0 32 bits: \n");
		imprimir_buffer_32bit(512,leer_fifo_32_bit(fifo0_32_bit_ptr));

		printf("\n\nResultados FIFO 1 32 bits: \n");
		imprimir_buffer_32bit(512,leer_fifo_32_bit(fifo1_32_bit_ptr));
	}


	return 0;
}

void imprimir_buffer_32bit(int N_datos,int* puntero_a_buffer){
	for(int i=0;i<N_datos;i++){
		printf("%d, ",(*(puntero_a_buffer+i)));
	}
}

void imprimir_buffer_64bit(int N_datos,long long* puntero_a_buffer){
	for(int i=0;i<N_datos;i++){
		printf("%lld, ",(*(puntero_a_buffer+i)));
	}
}

void setCoeff(int* filtro){

	for (int i = 0; i<10;i++){
			setParam(i,*(filtro+i),parameters_ptr);
			setParam(i,*(filtro+i+10),parameters_1_ptr);
			setParam(i,*(filtro+i+20),parameters_2_ptr);
		}
	setParam(0,*(filtro+30),parameters_3_ptr);
	setParam(1,*(filtro+31),parameters_3_ptr);
	setParam(2,*(filtro+32),parameters_3_ptr);
}


