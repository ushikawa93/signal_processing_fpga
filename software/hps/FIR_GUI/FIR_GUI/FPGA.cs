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

        public FPGA()
        {
            pipe = new PipeControl();
        }

        public void EnviarComando(int comando)
        {
            pipe.Enviar(comando);
        }

    }
}
