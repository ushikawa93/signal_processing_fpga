using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FIR_GUI
{
    public class Filtro
    {
        double f_muestreo;
        double fc_normalizada;
        List <int> coeficientes; 

        public Filtro(List <int> coef, double f_muestreo_i, double fc_normalizada_i  )
        {
            fc_normalizada = fc_normalizada_i;
            f_muestreo = f_muestreo_i;
            List <int> coeficientes = coef;
        }

        public double F_muestreo
        {
            set
            {
                f_muestreo = value;
            }
            get
            {
                return f_muestreo;
            }

        }

        public double F_corte
        {
            get
            {
                return (double)fc_normalizada * (double)f_muestreo /(double)2; 
            }
        }

        public List <int> Coeficientes
        {
            get
            {
                return coeficientes;
            }
            set
            {
                coeficientes = value;
            }
        }



    }
}
