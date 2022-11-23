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
        double f_muestreo;
        BancoFiltros filtros;

        int index_filtro_actual;

        public FIR_demo()
        {
            InitializeComponent();

            try
            {
                f_muestreo = 1000 * double.Parse(f_muestreo_textbox.Text);
            }
            catch (Exception e)
            {
                f_muestreo_textbox.Text = "1000";
                f_muestreo = 1000 * double.Parse(f_muestreo_textbox.Text);
            }

            filtros = new BancoFiltros(f_muestreo);
            index_filtro_actual = 0;

            label_frecuencia_corte.Text = filtros.getFiltro(index_filtro_actual, getTipoFiltroActual()).F_corte.ToString();

            fpga = new FPGA();            
        }

        private void Iniciar_button_Click(object sender, EventArgs e)
        {
            fpga.set_clk((int)f_muestreo);
            fpga.setFilter_to_FPGA(filtros.getFiltro(index_filtro_actual, getTipoFiltroActual()));
            fpga.Start();
        }


        private void refresh_button_Click(object sender, EventArgs e)
        {
            fpga.Reset();
            fpga.setFilter_to_FPGA(filtros.getFiltro(index_filtro_actual, getTipoFiltroActual()));
            fpga.Start();
        }

        private void finalizar_button_Click(object sender, EventArgs e)
        {
            fpga.Reset();
        }

        private void button_frecuencia_corte_up_Click(object sender, EventArgs e)
        {
            modify_filter_index(DIR.UP);
            label_frecuencia_corte.Text = filtros.getFiltro(index_filtro_actual, getTipoFiltroActual()).F_corte.ToString();
        }

        private void button_frecuencia_corte_down_Click(object sender, EventArgs e)
        {
            modify_filter_index(DIR.DOWN);
            label_frecuencia_corte.Text = filtros.getFiltro(index_filtro_actual, getTipoFiltroActual()).F_corte.ToString();
        }



        private void frec_muestreo_ok_Click(object sender, EventArgs e)
        {
            f_muestreo = 1000 * double.Parse(f_muestreo_textbox.Text);
            filtros.F_muestreo = f_muestreo;
            label_frecuencia_corte.Text = filtros.getFiltro(index_filtro_actual, getTipoFiltroActual()).F_corte.ToString();
        }

        private void exit_button_Click(object sender, EventArgs e)
        {
            fpga.Reset();
            fpga.Terminate();
        }

        private BancoFiltros.TIPOS_FILTRO getTipoFiltroActual()
        {
            if (button_PB.Checked) { return BancoFiltros.TIPOS_FILTRO.PB; }
            if (button_PA.Checked) { return BancoFiltros.TIPOS_FILTRO.PA; }
            if (button_bypass.Checked) { return BancoFiltros.TIPOS_FILTRO.BYPASS; }
            else return BancoFiltros.TIPOS_FILTRO.PB;
        }

        enum DIR { UP, DOWN};
        private void modify_filter_index(DIR direction)
        {
            if (direction == DIR.UP)
            {
                if (getTipoFiltroActual() == BancoFiltros.TIPOS_FILTRO.PB)
                {
                    index_filtro_actual = (index_filtro_actual == filtros.Filtros_PB.Count - 1) ? 0 : index_filtro_actual + 1;
                }
                if (getTipoFiltroActual() == BancoFiltros.TIPOS_FILTRO.PA)
                {
                    index_filtro_actual = (index_filtro_actual == filtros.Filtros_PA.Count - 1) ? 0 : index_filtro_actual + 1;
                }

            }
            if (direction == DIR.DOWN)
            {
                if (getTipoFiltroActual() == BancoFiltros.TIPOS_FILTRO.PB)
                {
                    index_filtro_actual = (index_filtro_actual == 0) ? filtros.Filtros_PB.Count - 1 : index_filtro_actual - 1;
                }
                if (getTipoFiltroActual() == BancoFiltros.TIPOS_FILTRO.PA)
                {
                    index_filtro_actual = (index_filtro_actual == 0) ? filtros.Filtros_PA.Count - 1 : index_filtro_actual - 1;
                }

            }

        }

        private void FIR_demo_FormClosed(object sender, FormClosedEventArgs e)
        {
            fpga.Reset();
            fpga.Terminate();
        }

    }
}
