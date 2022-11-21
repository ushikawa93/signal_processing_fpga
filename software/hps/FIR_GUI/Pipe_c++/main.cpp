
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

    // Comandos para controlar la cosa
    enum COMANDOS { RST , START, SET_CLK, SET_PARAM, GET_PARAM, RD_FIFO , TERMINATE = 99};
    enum FIFO_DIRECTION {  F0_32, F1_32, F0_64, F1_64  };
    bool terminate = false;

    // C# me manda enteros de 32 bits. Cada una es una instruccion. Una o mas instrucciones son un comando
        // RST -> Reinicia todo ( rst = 1)
        // START -> Empieza a adquirir y procesar (enable = 1)
        // SET_CLK VALUE -> Setea el clock al valor en value (en kHz)
        // SET_PARAM OFFSET VALUE -> Setea VALUE en el parametro OFFSET
        // GET_PARAM OFFSET -> Obtiene el parametro en OFFSET
        // RD_FIFO NUM -> Lee el FIFO NUM que es del tipo enum FIFO_DIRECTION (son 4 fifos 2 de 32b y 2 de 64b)
        // TERMINATE -> Finaliza el programa

    // Funciones para comunicacion con FPGA
    FPGA_de1soc fpga;   

    // Inicializa los pipes y deja todo preparado para recibir desde C#
    pipeControl PipeControl;
    
    while(!terminate)
    {
        // Me quedo esperando a que venga algun comando desde C#
        COMANDOS command = PipeControl.Recibir32();  // Conversion implicita ?
       
        switch (command)
        {
        case RST:
            fpga.Reset();
            break;
        
        case START:
            fpga.Comenzar();
            break;

        case SET_CLK:
            COMANDOS value = PipeControl.Recibir32();
            fpga.set_frec_clk(value);
            break;
                
        case SET_PARAM:
            COMANDOS offset = PipeControl.Recibir32();
            COMANDOS value = PipeControl.Recibir32();
            fpga.set_parameter(value,offset);
            break;    
        
        case GET_PARAM:
            COMANDOS offset = PipeControl.Recibir32();
            int value = fpga.get_parameter(offset);
            PipeControl.Enviar(value);
            break;    
        
        case RD_FIFO:
            FIFO_DIRECTION num = PipeControl.Recibir32();
            switch (num)
            {
            case F0_32:
                int value = fpga.LeerFIFO32individual(0);
                PipeControl.Enviar(value);
                break;

            case F1_32:
                int value = fpga.LeerFIFO32individual(1);
                PipeControl.Enviar(value);
                break;

            case F0_64:
                long long int value = fpga.LeerFIFO64individual(0);
                PipeControl.Enviar(value);
                break;

            case F1_64:
                long long int value = fpga.LeerFIFO64individual(1);
                PipeControl.Enviar(value);
                break;
            default:
                break;
            }
            break;    
        
        case TERMINATE:
            fpga.Reset();
            terminate = true;
            break;    

        default:        
            break;
        }      
    }
   

    return 0;
}
