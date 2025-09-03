# signal_processing_fpga
Modelo para procesamiento de señales en FPGAs de Intel/Altera

El diseño esta pensado en tres etapas, cada una programada en sendos módulos de Verilog. 

El Top File del modelo es el archivo *signal_processing_template.v*, que instancia los módulos y rutea la señales entre los distintos módulos.

## Módulo de control

Este módulo, en el archivo *control.v*, instancia un bloque de QSYS, el sistema de Quartus para integrar varias IPs. En este tenemos varias cosas:
	
>**Procesador NIOS:** Procesador que se forma con celdas lógicas de la FPGA. Para usarlo tambien se necesita un espacio de memoria y un programador JTAG, que estan ambos incluidos en el QSYS.
	Se puede programar de distintas maneras, la mas simple es usar Eclipse, mediante las *NIOS software build tools for eclipse*
	Si se usa esta opción se puede usar el workspace "signal_processing_fpga\software" que ya tiene todo listo para usar.
	
>**Hard processor system (HPS):** Procesador "real" incorporado en el chip de la FPGA (en Cyclone V seguro, no todas lo tienen)
	Se tiene que instanciar desde el QSYS para habilitar los "puentes" entre el HPS y las cosas de la FPGA.
	En este diseño se usa el mas simple de los puentes: "ligthweight axi bus"
	
>**PLL:** Instanciacion de un PLL disponible en el SoC-FPGA. A traves de una interfaz reconfigurable se puede setear su frecuencia en el rango [1-65] MHz.
	Ver mas adelante las herramientas HAL para ver como se puede configurar correctamente desde NIOS o HPS.
	Para lograr frecuencias menores hay un módulo "divisor_clock" por fuera del QSYS. Este divisor se puede controlar a través del NIOS o HPS.
	
>**Parameters:** Interfaz que permite reconfigurar en tiempo real las cosas de la FPGA. Tiene 40 parametros configurables, aunque se pueden poner más.
	
>**Señales de control:** enable, reset y finalizacion: permiten habilitar resetear y señalizar el fin del procesamiento.
	
>**FIFOs:** Memorias del tipo "first in first out", con interfaz de entrada "avalon streaming". 
	Esto significa que cada ciclo de reloj en que la señal de "valid" este en alto la memoria guarda la señal en "data".
	Hay 6 memorias, todas de 32 bits. 2 sirven como memorias independientes de 32 bits, y las otras 4 sirven de a dos como memorias de 64 bits (una para los bits bajos de la señal y otra para los altos).
			   
>**Resultados:** Esto es para tener resultados "instantaneos", en vez de la historia de la señal que se guardaría en los FIFOS.
	La lógica es la misma que en los FIFO, 6 PIOs de 32 bit, 2 para los de 32 bit, 4 para los de 64 bit

## Módulo de fuente de señal

Este módulo, en el archivo "data_in.v" tiene las señales de entrada para el procesamiento. Estas pueden ser 3:

>**Datos simulados:** Provee una señal sinusoidal digital que puede ser contaminada por ruido. Tiene tres parametros configurables:
	-> simulation_noise: Amplitud de ruido de la simulacion.
	-> ptos_x_ciclo: Puntos por ciclo de la señal sinusoidal.
	-> seleccion_ruido: Selecciona como se genera el ruido de la simulacion: 0: LFSR y 1: Generador congruencial lineal.
	
>**ADC High-speed (*adc_driver.v*):** Driver del AD9248, de 65 MHz de frecuencia de muestreo máxima y dos canales paralelos.
	En cada ciclo del reloj "clk_adc" provee una muestra en "data_canal_a" y "data_canal_b", y pone en alto la señal "data_adc_valid".
	
>**ADC LTC 2308 (*embedded_adc.v*):** Driver del ADC LTC2308, de 500 kHz de frecuencia de muestreo maxima. La operacion es un poco distinta, debe recibir una frecuencia de clock de 40 MHz.
	A traves del parametro "f_muestreo" se setea la frecuencia del timer que dispara la adquisición.
	A traves del parámetro "SEL_CH" se selecciona el canal del ADC a adquirir (estos no son independientes sino multiplexados)
	El ADC provee una muestra valida en todo ciclo del reloj en que la señal "adc_2308_valid" este en alto.
									   
>**DAC highspeed (*dac_driver.v*) EXTRA!:** Driver del AD9767, un DAC de 125 MHz de frecuencia máxima de operacion.
	Tiene dos modos: 
	*uno convierte en analogico la señal almacenada en una LU TABLE,
	*el otro convierte en analogico la señal que va recibiendo en la entrada "digital_data_in"
											

## Módulo de procesamiento

Este módulo en el archivo *signal_processing.v* es donde el diseñador debe incorporar los algoritmos de procesamiento.
Sin importar que fuente de señal se elija los datos ingresan al módulo de a uno en cada ciclo de reloj en que la señal "valid" este en alto.
El procesamiento se puede dividir en varios subsistemas, en donde todos deben cumplir con esta interfaz.
Los datos de salida tambien deben proveerse con un "data_out_valid".

En este ejemplo el procesamiento que se realiza en la señal es un filtrado, con un filtro FIR de orden 32. El filtrado se hace en tres ciclos de reloj (pipeline de 3 etapas)
Los coeficientes del filtro se pueden modificar en tiempo real, mediante la interfaz de parámetros del elemento de control.

La señal "ready_to_calculate" permite señalizar a modulos externos que esta todo listo para empezar a procesar (puede ser util si hay que limpiar buffers o calcular alguna cosa antes de empezar).

## Capa de abstraccion de hardware (HAL)

Serie de funciones diseñadas para el NIOS y el HPS que permiten controlar la FPGA abstrayendonos un poco del hardware.

### **Para usar el NIOS:**
Primero se genera el board support package (BSP) con la herramienta de Eclipse. Esto genera un archivo *system.h* que tiene los base address de todas las cosas que instanciamos en el QSYS del control.
Las funciones reciben un puntero a las direcciones de memoria de los modulos que queremos afectar.
Todas estas funciones estan definidas en software/signal_processing


>- funciones_pll.c: 
>   - setClockDivider (int divisor_deseado, int * clk_divider_addr):  Setea el divisor del clock del PLL en el valor dado por divisor_deseado
>   - configurar_pll(int frec_deseada,int * pll_reconfig): Setea el clock del PLL en un rango entre 1 y 65 MHz. Recibe la f deseada en MHz.
	
>- control_functions.h: (Estas son bastante auto explicativas...)
>   - setEnable(int* enable_ptr)
>   - unsetEnable(int* enable_ptr)
>   - Reset(int*enable_ptr,int*reset_ptr)
>   - getFin(int* finish_ptr)
>   - waitForFin(int *finish_ptr)
	
>- parameters_control.h
>   - setParam(int parametro,int value,int * parameters_addr): Setea el parametro "parametro" con el valor "value".
>   - getParam(int parametro,int * parameters_addr): Obtiene el valor del parametro "parametro".
		
>- result_functions.h
>   - leer_fifo_32_bit(int* fifo_addr): Lee alguna de las memorias FIFO de 32 bits. Devuelve un puntero al arreglo que tiene guardada toda la memoria
>   - leer_fifo_64_bit(unsigned int* fifo_down_addr,unsigned int* fifo_up_addr). Lo mismo pero con los FIFO de 64 bits (Que en realidad son dos de 32 como deciamos hace un rato)
>   - leer_resultado_32_bit(int* pio_addr): Devuelve un entero con el ultimo resultado del procesamiento.
>   - leer_resultado_64_bit(unsigned int* pio_down_addr,unsigned int* pio_up_addr): Lo mismo con datos de 64 bits.
		
### **Para usar el HPS:**
En este caso la HAL es a través de una clase *FPGA* escrita en c++. 
El archivo "FPGA_MACROS.h" define las direcciones de memoria de las cosas de la FPGA (cumple la misma funcion de *system.h* arriba).
La clase esta definida en "FPGA_de1soc.h", y se vale de un mapeo a la direccion de memoria /dev/mem que es donde el "lightweight axi bus" hace su magia. Este mapeo tiene lugar en una instancia de la clase "FPGA_IO_simple.h". 

La interfaz pública de la clase se compone de las funciones. Las funciones son análogas a las generadas para el HAL del NIOS, se omiten las descripciones:

>- Comenzar()
>- Calcular()
>- Terminar()
>- set_N_parametros(int N, int* paramters_array)
>- set_parameter(int value,int parameter_index)
>- set_frec_clk (int frec_clk_i) 
>- set_divisor_clock (int div_clk_i)
>- set_clk_from_frec (int frecuencia)
>- get_parameter(int parameter_index)
>- leer_FIFO_32_bit(int fifo)
>- leer_resultado_32_bit(int fifo)
>- leer_FIFO_64_bit(int fifo)
>- leer_resultado_64_bit(int fifo)

Esta clase, junto con un main() que demuestra su uso, estan definidas en "software/hps/signal_processing"

## Graphical User Interface (GUI)

Para esta demostración también se programó una GUI en C#, que se ejecuta en el procesador de la FPGA (que tiene un Ubuntu) a través de la implementacion mono de .Net
Esta GUI usa named PIPES para interfacear con la HAL. Primero hay que compilar en la plataforma de destino el fpga_driver (hay un makefile).

Luego para que funcione correctamente debe ejecutarse al mismo tiempo el driver en c++ que usa la HAL y el .exe que genera la GUI.

Puede hacerse fácil con un shell script:	./fpga_driver && mono FIR_GUI.exe

La GUI permite visualizar señales, iniciar el procesamiento y setear los coeficientes del filtro, entre otras funcionalidades.

Todas estas funcionalidades estan en "software/hps/FIR_GUI"

## Licencia
Este proyecto cuenta con licencia conforme a los términos de la licencia MIT
