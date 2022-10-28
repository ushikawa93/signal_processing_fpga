
/* 
	Programa principal
*/

#include <iostream>
#include <fstream>
#include <string>
#include "FPGA_de1soc.h"
#include "lockin_functions.h"

#define CLEAR_CONSOLE "\033[2J\033[1;1H"  // Mandando este valor a cout limpio la pantalla
#define N_CRUDOS 512
#define RAW_FIFO_DEPTH 8192

using namespace std;


int main(int argc, char *argv[]) 
{
    FPGA_de1soc fpga;
    Lockin_functions lia;

    int N_ma = 8;
	int N_promC = 8;
	int div = 32*N_ma*N_promC;
	int noise = 0;
 
    fpga.set_frec_clk(40);
    fpga.set_divisor_clock(1);    

    fpga.set_parameter(noise,0);
    fpga.set_parameter(N_ma,1);
    fpga.set_parameter(N_promC,2);

    fpga.Calcular();

    long long X = fpga.leer_resultado_64_bit(0) ;
    long long Y = fpga.leer_resultado_64_bit(1) ;

    std::cout << std::endl << "X: " << X << std::endl;
    std::cout << "Y: " << Y << std::endl;


    std::cout << "Datos crudos: " << endl;

    int* datos_crudos=fpga.leer_FIFO_32_bit(0);

    for(int i =0;i<128;i++){
        std::cout << *(datos_crudos+i) << ", ";
    }


    double amplitud = lia.amplitud_lockin(X,Y,div);
    double fase = lia.fase_lockin(X,Y,div);

    std::cout << std::endl << "Amplitud: " << amplitud << std::endl;
    std::cout << "Fase: " << fase << std::endl;

    fpga.Terminar();

}
