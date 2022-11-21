using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FIR_GUI
{
    class BancoFiltros
    {
        List <Filtro> filtros_PB;
        List <Filtro> filtros_PA;
        float f_muestreo;

        public enum TIPOS_FILTRO = { PA , PB , BYPASS};
        
        // Filtros Pasa-bajos
        List <int> PB_0_05 = {83,	118,	188,	306,	482,	724,	1031,	1400,	1820,	2272,	2737,	3189,	3604,	3957,	4227,	4395,	4453,	4395,	4227,	3957,	3604,	3189,	2737,	2272,	1820,	1400,	1031,	724,	482,	306,	188,	118,	83};
        List <int>  PB_0_1 = {-101,	-125,	-165,	-207,	-222,	-169,	0,	325,	835,	1533,	2391,	3352,	4334,	5241,	5975,	6453,	6619,	6453,	5975,	5241,	4334,	3352,	2391,	1533,	835,	325,	0,	-169,	-222,	-207,	-165,	-125,	-101};
        List <int>  PB_0_15 = {98,	87,	52,	-40,	-219,	-480,	-757,	-927,	-825,	-293,	766,	2339,	4277,	6314,	8115,	9355,	9797,	9355,	8115,	6314,	4277,	2339,	766,	-293,	-825,	-927,	-757,	-480,	-219,	-40,	52,	87,	98};
        List <int>  PB_0_2 = {-62,	0,	100,	240,	354,	316,	-1,	-614,	-1339,	-1785,	-1463,	0,	2651,	6097,	9567,	12147,	13100,	12147,	9567,	6097,	2651,	0,	-1463,	-1785,	-1339,	-614,	-1,	316,	354,	240,	100,	0,	-62};
        List <int>  PB_0_25 = { -1,	-88,	-172,	-180,	0,	382,	761,	739,	-1,	-1331,	-2496,	-2353,	0,	4546,	10088,	14654,	16422,	14654,	10088,	4546,	0,	-2353,	-2496,	-1331,	-1,	739,	761,	382,	0,	-180,	-172,	-88,	-1};
        List <int>  PB_0_3 = {61,	123,	100,	-78,	-355,	-436,	-1,	842,	1335,	578,	-1460,	-3311,	-2646,	1976,	9546,	16682,	19607,	16682,	9546,	1976,	-2646,	-3311,	-1460,	578,	1335,	842,	-1,	-436,	-355,	-78,	100,	123,	61};

        // Filtros Pasa-altos
        List <int>  PA_0_05 = {-62,	-88,	-139,	-226,	-356,	-534,	-760,	-1032,	-1341,	-1674,	-2016,	-2349,	-2655,	-2915,	-3113,	-3238,	62309,	-3238,	-3113,	-2915,	-2655,	-2349,	-2016,	-1674,	-1341,	-1032,	-760,	-534,	-356,	-226,	-139,	-88,	-62};
        List <int>  PA_0_1  = {99,	123,	162,	204,	219,	166,	-1,	-323,	-827,	-1517,	-2365,	-3315,	-4286,	-5183,	-5908,	-6381,	58900,	-6381,	-5908,	-5183,	-4286,	-3315,	-2365,	-1517,	-827,	-323,	-1,	166,	219,	204,	162,	123,	99};
        List <int>  PA_0_15  = {-100,	-88,	-54,	39,	219,	481,	760,	931,	828,	294,	-771,	-2351,	-4299,	-6346,	-8156,	-9402,	55793,	-9402,	-8156,	-6346,	-4299,	-2351,	-771,	294,	828,	931,	760,	481,	219,	39,	-54,	-88,	-100};
        List <int>  PA_0_2  = {61,	0,	-101,	-241,	-355,	-317,	-1,	612,	1337,	1782,	1461,	0,	-2649,	-6093,	-9561,	-12138,	52360,	-12138,	-9561,	-6093,	-2649,	0,	1461,	1782,	1337,	612,	-1,	-317,	-355,	-241,	-101,	0,	61};
        List <int>  PA_0_25  = {-1,	87,	171,	178,	-1,	-382,	-760,	-739,	-1,	1327,	2491,	2348,	-1,	-4539,	-10072,	-14630,	49182,	-14630,	-10072,	-4539,	-1,	2348,	2491,	1327,	-1,	-739,	-760,	-382,	-1,	178,	171,	87,	-1};
        List <int>  PA_0_3  = {-62,	-124,	-101,	78,	355,	436,	0,	-845,	-1340,	-581,	1463,	3320,	2653,	-1983,	-9576,	-16733,	45888,	-16733,	-9576,	-1983,	2653,	3320,	1463,	-581,	-1340,	-845,	0,	436,	355,	78,	-101,	-124,	-62};

        public BancoFiltros(float f_muestreo_i)
        {
            filtros_PB.Add(new Filtro(PB_0_05,f_muestreo,0.05));
            filtros_PB.Add(new Filtro(PB_0_1,f_muestreo,0.1));
            filtros_PB.Add(new Filtro(PB_0_15,f_muestreo,0.15));
            filtros_PB.Add(new Filtro(PB_0_2,f_muestreo,0.2));
            filtros_PB.Add(new Filtro(PB_0_25,f_muestreo,0.25));
            filtros_PB.Add(new Filtro(PB_0_3,f_muestreo,0.3));

            filtros_PA.Add(new Filtro(PA_0_05,f_muestreo,0.05));
            filtros_PA.Add(new Filtro(PA_0_1,f_muestreo,0.1));
            filtros_PA.Add(new Filtro(PA_0_15,f_muestreo,0.15));
            filtros_PA.Add(new Filtro(PA_0_2,f_muestreo,0.2));
            filtros_PA.Add(new Filtro(PA_0_25,f_muestreo,0.25));
            filtros_PA.Add(new Filtro(PA_0_3,f_muestreo,0.3));

            f_muestreo = f_muestreo_i;

        }

        public float F_muestreo
        {
            set
            {
                foreach (Filtro in filtros_PA)
                {
                    Filtro.F_muestreo = value;
                }
                foreach(Filtro in filtros_PB)
                {
                    Filtro.F_muestreo == value;
                }
                f_muestreo = f_muestreo_i
            }
            get
            {
                return f_muestreo;
            }
        }

        public void AddFilter( List <int> coef, float f_muestreo_i, float fc_normalizada_i , TIPOS_FILTRO tipo_filtro)
        {
            if (f_muestreo_i != f_muestreo)
            {
                F_muestreo = f_muestreo_i;
            }

            if(tipo_filtro == PA)
            {
                filtros_PA.Add(new Filter (coef,f_muestreo,fc_normalizada ));

            }
            else if (tipo_filtro == PB)
            {
                filtros_PB.Add(new Filter (coef,f_muestreo,fc_normalizada ));
            }

        }

        public List<int> Filtros_PB()
        {
            return filtros_PB;
        }
        public List<int> Filtros_PA()
        {
            return filtros_PA;
        }


    }
}