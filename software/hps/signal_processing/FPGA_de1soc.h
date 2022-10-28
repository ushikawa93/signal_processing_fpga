
/*
	Clase que controla el comportamiento de la FPGA
*/


#include "FPGA_IO_simple.h"
#include "FPGA_macros.h"
#include <cstdlib>
#include <cmath>

//using namespace std;

class FPGA_de1soc {

	private:
	
		// Arreglos con los datos
		int fifo0_32_bit[BUFFER_SIZE_RAW];	
		int fifo1_32_bit[BUFFER_SIZE_RAW];	

		long long fifo0_64_bit[BUFFER_SIZE_RAW];
		long long fifo1_64_bit[BUFFER_SIZE_RAW];

		int parameter_0,parameter_1, parameter_2, parameter_3, parameter_4, parameter_5, parameter_6, parameter_7 , parameter_8, parameter_9, parameter_10;
		int frec_clk,div_clk;
		bool calculos_disponibles;
		FPGA_IO_simple fpga;

		//--------------- Funciones de control -------------------------------//
		// Funciones para controlar el flujo de datos en la FPGA. Las hago privadas para que
		// el usuario no interactue directamente con ellas
		void Iniciar()
		{
			fpga.WriteFPGA(ENABLE_BASE, 0 , 1);
		}
		void Reset()
		{
			fpga.WriteFPGA(ENABLE_BASE, 0, 0);
			fpga.WriteFPGA(RESET_BASE , 0, 1);
			fpga.WriteFPGA(RESET_BASE , 0, 0);
		}
		void Esperar()
		{
			while (fpga.ReadFPGA(FINALIZACION_BASE,0) == 0){}
		}
		
		// Funcion para transformar "cuentas" del ADC en valores de tensión
		double toVolt_ADC_HS(double tension)
        {
            double factor_conversion_a_volt = 1.93/(7423); //Medido con osciloscopio				
            return tension * factor_conversion_a_volt;            
        }       
		
		
	public:	

		//--------------- Funciones de control -------------------------------//
		void Calcular()
		{
			Reset();	
			Iniciar();
			Esperar();
			calculos_disponibles=true;
		}
		void Terminar()
		{
			Reset();
			calculos_disponibles=false;
		}


		//--------------- Funciones de parámetros -------------------------------//
		// Inicializo la FPGA con 0s por defecto:
		
		FPGA_de1soc(){
			set_parametros (0,0,0,0,0,0,0,0,0,0,0); 	
			calculos_disponibles=false;	
		}	
		
		void set_parametros (int parameter_0,
							 int parameter_1,
							 int parameter_2,
							 int parameter_3,
							 int parameter_4,
							 int parameter_5,
							 int parameter_6,
							 int parameter_7,
							 int parameter_8,
							 int parameter_9,
							 int parameter_10
							 )
							{	
								set_parameter(parameter_0,0);
								set_parameter(parameter_1,1);
								set_parameter(parameter_2,2);
								set_parameter(parameter_3,3);
								set_parameter(parameter_4,4);
								set_parameter(parameter_5,5);
								set_parameter(parameter_6,6);
								set_parameter(parameter_7,7);
								set_parameter(parameter_8,8);
								set_parameter(parameter_9,9);
								set_parameter(parameter_10,10);
							}

		// Setters de cada parametro configurable de la FPGA	
		void set_parameter(int value,int parameter){
			switch(parameter){
				case 0:
					parameter_0 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_0,  parameter_0 );		
					break;
				case 1:
					parameter_1 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_1,  parameter_1 );	
					break;
				case 2:
					parameter_2 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_2,  parameter_2 );	
					break;
				case 3:
					parameter_3 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_3,  parameter_3 );	
					break;
				case 4:
					parameter_4 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_4,  parameter_4 );	
					break;
				case 5:
					parameter_5 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_5,  parameter_5 );	
					break;
				case 6:
					parameter_6 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_6,  parameter_6 );	
					break;
				case 7:				
					parameter_7 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_7,  parameter_7 );	
					break;
				case 8:
					parameter_8 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_8,  parameter_8 );	
					break;
				case 9:
					parameter_9 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_9,  parameter_9 );	
					break;
				case 10:
					parameter_10 = value;
					fpga.WriteFPGA ( PARAMETERS_BASE, PARAMETER_10,  parameter_10 );	
					break;
				default:
					break;
			}
		}

		void set_frec_clk (int frec_clk_i) 
		{
			frec_clk=frec_clk_i;
			fpga.ConfigurarPll ( frec_clk );	
		}

		void set_divisor_clock (int div_clk_i) 
		{
			div_clk=div_clk_i;
			fpga.WriteFPGA ( DIVISOR_CLOCK_BASE, 0,  div_clk );	
		}

		
		// Setea la frec de lockin dejando ptos_x_ciclo constante (cambia frec_clk y divisor del clock)
		// es medio bruto el algoritmo asi, estaria bueno optimizarlo un poco
		void set_clk_from_frec (int frecuencia,int pts_x_ciclo)
		{
			double frec,divisor;
			
			double min_divisor=1;
			double max_divisor=100000;
			
			double min_error = 10000000;
            double frec_final = 1;
			double divisor_final = 1;
			int ready_flag = 0;
			
			for (frec = 1; frec <= 65; frec = frec + 1)
            {
				for(divisor = min_divisor; divisor <= max_divisor; divisor++)
				{
					double error = std::abs(frecuencia - frec * 1000000 / (divisor*pts_x_ciclo));
					if (error == 0)
					{
						ready_flag=1;
						frec_final = frec;
						divisor_final = divisor;	
						break;						
					}					
					else if (error < min_error)
					{
						min_error = error;
						frec_final = frec;
						divisor_final = divisor;						
					}
				}
				if(ready_flag==1)
				{
					break;
				}
            }
			
			set_frec_clk(frec_final);
			set_divisor_clock(divisor_final);
		}

		// Geters para que el programa ppal consulte el estado de la FPGA	
		int get_parameter(int parameter)
		{
			switch(parameter){
				case 0:
					return parameter_0;
				case 1:
					return parameter_1;
				case 2:
					return parameter_2;
				case 3:
					return parameter_3;
				case 4:
					return parameter_4;
				case 5:
					return parameter_5;
				case 6:
					return parameter_6;
				case 7:				
					return parameter_7;
				case 8:
					return parameter_8;
				case 9:
					return parameter_9;
				case 10:
					return parameter_10;
				default:
					return 0;

			}

		}

		//------------------------ Funciones de resultados -------------------------------//
		// Devuelve un puntero al arreglo que tiene guardado los datos de los FIFO de 32 bits
		int * leer_FIFO_32_bit(int fifo)
		{			
			if(calculos_disponibles)
			{
				int indice;
				for(indice=0; indice < BUFFER_SIZE_RAW; indice++)
				{
					if(fifo==0)
					{
						int sample = (int)fpga.ReadFPGA( FIFO0_32_BIT_BASE,0 );
						fifo0_32_bit[indice] = sample;	
					}
					else if(fifo=1)
					{
						int sample = (int)fpga.ReadFPGA( FIFO1_32_BIT_BASE,0 );
						fifo1_32_bit[indice] = sample;	
					}
					
				}
				if(fifo==0)
				{
					return fifo0_32_bit;
				}
				else
				{
					return fifo1_32_bit;
				}
			}
			return 0;		
		}		

		int leer_resultado_32_bit(int fifo)
		{
			if(calculos_disponibles){
				if(fifo == 0)
				{
					return (int)fpga.ReadFPGA( FIFO0_32_BIT_BASE,0 );
				}
				else
				{
					return (int)fpga.ReadFPGA( FIFO1_32_BIT_BASE,0 );
				}
				
			}
			return 0;			
		}


		long long * leer_FIFO_64_bit(int fifo)
		{	
			if(calculos_disponibles)
			{
				int indice;
				for(indice=0; indice < BUFFER_SIZE_RAW; indice++)
				{
					if(fifo==0)
					{
						long long res_up = fpga.ReadFPGA( FIFO0_64_BIT_UP_BASE,0 );		
						long long res_low = fpga.ReadFPGA( FIFO0_64_BIT_DOWN_BASE,0 );			
						fifo0_64_bit[indice] =  (res_up << 32) | res_low ;
					}
					else if(fifo=1)
					{
						long long res_up = fpga.ReadFPGA( FIFO1_64_BIT_UP_BASE,0 );		
						long long res_low = fpga.ReadFPGA( FIFO1_64_BIT_DOWN_BASE,0 );			
						fifo0_64_bit[indice] =  (res_up << 32) | res_low ;
					}
					
				}

				if(fifo==0)
				{
					return fifo0_64_bit;
				}
				else
				{
					return fifo0_64_bit;
				}
			}
			return 0;			
		}		

		long long leer_resultado_64_bit(int fifo)
		{
			if(calculos_disponibles)
			{
				if(fifo == 0)
				{
					long long res_up = fpga.ReadFPGA( RESULT0_64_BIT_UP_BASE,0 );		
					long long res_low = fpga.ReadFPGA( RESULT0_64_BIT_DOWN_BASE,0 );			
					return (res_up << 32) | res_low ;
				}
				else
				{
					long long res_up = fpga.ReadFPGA( RESULT1_64_BIT_UP_BASE,0 );		
					long long res_low = fpga.ReadFPGA( RESULT1_64_BIT_DOWN_BASE,0 );			
					return (res_up << 32) | res_low ;
				}
			}
			return 0;
		}

};
