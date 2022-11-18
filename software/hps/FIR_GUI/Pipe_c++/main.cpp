
/* 
	Programa principal
*/

#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>

#include "FPGA_de1soc.h"
#include "filters.h"
#include "pipeControl.h"

#define CLEAR_CONSOLE "\033[2J\033[1;1H"  // Mandando este valor a cout limpio la pantalla
#define N_CRUDOS 512
#define RAW_FIFO_DEPTH 8192

using namespace std;

int main()
{    
    FPGA_de1soc fpga;   

    pipeControl PipeControl;

    while(1)
    {
        int led_state = PipeControl.Recibir32();
        fpga.set_parameter(led_state,34);
    }
   

    return 0;
}
