using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FIR_GUI
{
    public partial class FIR_demo : Form
    {
        FPGA fpga;

        public FIR_demo()
        {            
            InitializeComponent();
            fpga = new FPGA();
        }

        private void Iniciar_button_Click(object sender, EventArgs e)
        {
            fpga.Start(); 
            
            fpga.EnviarComando(1);

            // Configurar parametros
            // Enviar comando de inicio a la FPGA
        }


        private void refresh_button_Click(object sender, EventArgs e)
        {
            // Enviar comando de finalizacion a la FPGA
            // Configurar parametros
            // Enviar comando de inicio a la FPGA
        }

        private void finalizar_button_Click(object sender, EventArgs e)
        {
            fpga.EnviarComando(0);
            // Enviar comando de finalizacion a la FPGA
        }

        private void button_frecuencia_corte_up_Click(object sender, EventArgs e)
        {
            // Subir la frecuencia del filtro utilizado
            // Modificar el label correspondiente
        }

        private void button_frecuencia_corte_down_Click(object sender, EventArgs e)
        {
            // Bajar la frecuencia del filtro utilizado
            // Modificar el label correspondiente
        }



        private void frec_muestreo_ok_Click(object sender, EventArgs e)
        {  
            // Modificar la frecuencia de muestreo  
            // Modificar frecuencia de corte de los filtros
        }
    }
}
