using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FIR_GUI
{
    class Filtro
    {
        float f_muestreo;
        float fc_normalizada;
        List <int> coeficientes; 

        public Filtro(List <int> coef, float f_muestreo_i, float fc_normalizada_i  )
        {
            fc_normalizada = fc_normalizada_i;
            f_muestreo = f_muestreo_i;
            List <int> coeficientes = coef;
        }

        public float F_muestreo
        {
            set
            {
                f_muestreo = value;
            }

        }

        public float F_corte
        {
            get
            {
                return fc_normalizada * f_muestreo /2; 
            }
        }

        public List <int> Coeficientes
        {
            get
            {
                return coeficientes;
            }
        }



    }
}
