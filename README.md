# signal_processing_fpga
Modelo para procesamiento de señales en FPGAs de Intel/Altera

## Estructura general del diseño
El diseño esta pensado en tres etapas, cada una programada en sendos módulos de Verilog. 

El Top File del modelo es el archivo *signal_processing_template.v*, que instancia los módulos y rutea la señales entre los distintos módulos.

### Módulo de control

Este módulo, en el archivo *control.v*, instancia un bloque de QSYS, el sistema de Quartus para integrar varias IPs. En este tenemos varias cosas:
	
	* Procesador NIOS: * Procesador que se forma con celdas lógicas de la FPGA. Para usarlo tambien se necesita un espacio de memoria y un programador JTAG, que estan ambos incluidos en el QSYS.
						 Se puede programar de distintas maneras, la mas simple es usar Eclipse, mediante las *NIOS software build tools for eclipse*
						 Si se usa esta opción se puede usar el workspace "signal_processing_fpga\software" que ya tiene todo listo para usar.
	
	* Hard processor system (HPS): * Procesador "real" incorporado en el chip de la FPGA (en Cyclone V seguro, no todas lo tienen)
									 Se tiene que instanciar desde el QSYS para habilitar los "puentes" entre el HPS y las cosas de la FPGA.
									 En este diseño se usa el mas simple de los puentes: "ligthweight axi bus"
	
	* PLL: * Instanciacion de un PLL disponible en el SoC-FPGA. A traves de una interfaz reconfigurable se puede setear su frecuencia en el rango [1-65] MHz.
			 Ver mas adelante las herramientas HAL para ver como se puede configurar correctamente desde NIOS o HPS.
			 Para lograr frecuencias menores hay un módulo "divisor_clock" por fuera del QSYS. Este divisor se puede controlar a través del NIOS o HPS.
	
	* Parameters: * Interfaz que permite reconfigurar en tiempo real las cosas de la FPGA. Tiene 40 parametros configurables, aunque se pueden poner más.
	
	* Señales de control: * enable, reset y finalizacion: permiten habilitar resetear y señalizar el fin del procesamiento.
	
	* FIFOs: * Memorias del tipo "first in first out", con interfaz de entrada "avalon streaming". 
			   Esto significa que cada ciclo de reloj en que la señal de "valid" este en alto la memoria guarda la señal en "data".
			   Hay 6 memorias, todas de 32 bits. 2 sirven como memorias independientes de 32 bits, y las otras 4 sirven de a dos como memorias de 64 bits (una para los bits bajos de la señal y otra para los altos).
			   
	* Resultados: * Esto es para tener resultados "instantaneos", en vez de la historia de la señal que se guardaría en los FIFOS.
					La lógica es la misma que en los FIFO, 6 PIOs de 32 bit, 2 para los de 32 bit, 4 para los de 64 bit

### Módulo de fuente de señal

Este módulo, en el archivo "data_in.v" tiene las señales de entrada para el procesamiento. Estas pueden ser 3:

	* Datos simulados: * Provee una señal sinusoidal digital que puede ser contaminada por ruido. Tiene tres parametros configurables:
		-> simulation_noise: Amplitud de ruido de la simulacion.
		-> ptos_x_ciclo: Puntos por ciclo de la señal sinusoidal.
		-> seleccion_ruido: Selecciona como se genera el ruido de la simulacion: 0: LFSR y 1: Generador congruencial lineal.
	
	* ADC High-speed (adc_driver.v): * Driver del AD9248, de 65 MHz de frecuencia de muestreo máxima y dos canales paralelos.
									   En cada ciclo del reloj "clk_adc" provee una muestra en "data_canal_a" y "data_canal_b", y pone en alto la señal "data_adc_valid".
	
	* ADC LTC 2308 (embedded_adc.v): * Driver del ADC LTC2308, de 500 kHz de frecuencia de muestreo maxima. La operacion es un poco distinta, debe recibir una frecuencia de clock de 40 MHz.
									   A traves del parametro "f_muestreo" se setea la frecuencia del timer que dispara la adquisición.
									   A traves del parámetro "SEL_CH" se selecciona el canal del ADC a adquirir (estos no son independientes sino multiplexados)
									   El ADC provee una muestra valida en todo ciclo del reloj en que la señal "adc_2308_valid" este en alto.
									   
	* DAC highspeed (dac_driver.v) EXTRA!: * Driver del AD9767, un DAC de 125 MHz de frecuencia máxima de operacion.
											 Tiene dos modos: uno convierte en analogico la señal almacenada en una LU TABLE,
															  el otro convierte en analogico la señal que va recibiendo en la entrada "digital_data_in"
											

### Módulo de procesamiento

Este módulo en el archivo "signal_processing.v" es donde el diseñador debe incorporar los algoritmos de procesamiento.
Sin importar que fuente de señal se elija los datos ingresan al módulo de a uno en cada ciclo de reloj en que la señal "valid" este en alto.
El procesamiento se puede dividir en varios subsistemas, en donde todos deben cumplir con esta interfaz.
Los datos de salida tambien deben proveerse con un "data_out_valid".

En este ejemplo el procesamiento que se realiza en la señal es un filtrado, con un filtro FIR de orden 32. El filtrado se hace en tres ciclos de reloj (pipeline de 3 etapas)
Los coeficientes del filtro se pueden modificar en tiempo real, mediante la interfaz de parámetros del elemento de control.

La señal "ready_to_calculate" permite señalizar a modulos externos que esta todo listo para empezar a procesar (puede ser util si hay que limpiar buffers o calcular alguna cosa antes de empezar).

### Capa de abstraccion de hardware (HAL)

Serie de funciones diseñadas para el NIOS y el HPS que permiten controlar la FPGA abstrayendonos un poco del hardware.

Para usar el NIOS:
Primero se genera el board support package (BSP) con la herramienta de Eclipse. Esto genera un archivo "system.h" que tiene los base address de todas las cosas que instanciamos en el QSYS del control.


	-> funciones_pll.c: 
		-> setClockDivider (int divisor_deseado,int*clk_divider_addr)











