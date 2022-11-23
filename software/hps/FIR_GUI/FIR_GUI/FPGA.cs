using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



namespace FIR_GUI
{
    public class FPGA
    {
        PipeControl pipe;

        // Comandos para controlar la cosa
        enum COMANDOS { RST , START, SET_CLK, SET_PARAM, GET_PARAM, RD_FIFO , TERMINATE = 99};
        public enum FIFO_DIRECTION {  F0_32, F1_32, F0_64, F1_64  };

        // C# le manda enteros de 32 bits a C++. Cada una es una instruccion. Una o mas instrucciones son un comando
            // RST -> Reinicia todo ( rst = 1)
            // START -> Empieza a adquirir y procesar (enable = 1)
            // SET_CLK VALUE -> Setea el clock al valor en value (en kHz)
            // SET_PARAM OFFSET VALUE -> Setea VALUE en el parametro OFFSET
            // GET_PARAM OFFSET -> Obtiene el parametro en OFFSET
            // RD_FIFO NUM -> Lee el FIFO NUM que es del tipo enum fifo_direction (son 4 fifos 2 de 32b y 2 de 64b)
            // TERMINATE -> Finaliza el programa

        public FPGA()
        {
            pipe = new PipeControl();
        }

        public void Start()
        {
            EnviarComando(COMANDOS.START);
            return;
        }

        public void Reset()
        {
            EnviarComando(COMANDOS.RST);
            return;
        }

        public void set_clk(int value)
        {
            EnviarComando(COMANDOS.SET_CLK);
            EnviarValor(value);
            return;
        }

        public void set_param(int param_index, int value)
        {
            EnviarComando(COMANDOS.SET_PARAM);
            EnviarValor(param_index);
            EnviarValor(value);
            return;
        }

        public int get_param(int param_index)
        {
            EnviarComando(COMANDOS.GET_PARAM);
            EnviarValor(param_index);
            return RecibirComando();
        }

        public void Terminate(){
            EnviarComando(COMANDOS.TERMINATE);
            return;
        }

        public void set_N_param ( int start_index ,  List <int> parametros  )
        {
            int param_index = start_index;
            foreach (int param in parametros)
            {
                set_param( param_index, param );
                param_index++;                                
            }
            return; 
        }
        
        public List <int> get_from_fifo (FIFO_DIRECTION fifo_direction, int N)
        {
            List <int> values= new List<int>();
            for (int i = 0; i< N; i++)
            {
                values.Add(get_fifo(fifo_direction));
            }
            return values;
        }

        private int get_fifo (FIFO_DIRECTION fifo_direction)
        {
            EnviarComando(COMANDOS.RD_FIFO);
            EnviarValor((int)fifo_direction);
            if( fifo_direction == FIFO_DIRECTION.F0_32 ||  fifo_direction == FIFO_DIRECTION.F1_32)
            {
                return pipe.Recibir();
            }
            else
            {
                // Esto todavia no esta andando igual, por ahora devuelvo enteros
                return pipe.Recibir();
            }
        }

        public void setFilter_to_FPGA( Filtro filter )
        {
            set_N_param (0, filter.Coeficientes);
        }

        private void EnviarComando(COMANDOS command)
        {
            pipe.Enviar((int)command);
            return;
        }

        private void EnviarValor(int value)
        {
            pipe.Enviar((int)value);
            return;
        }

        private int RecibirComando()
        {
            return pipe.Recibir();
        }

        
    }
}
