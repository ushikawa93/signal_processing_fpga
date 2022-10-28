/*
 * lockin_results.h
 *
 *  Funciones para calcular amplitud y fase de una
 *  transferencia a partir del X e Y
 *
 */

#include <cmath>
#define amplitud_ref 32767;

class Lockin_functions{

public: 
    double amplitud_lockin(long long X, long long Y,int div){
        long double X_1= X/div;
        long double Y_1= Y/div;
        return sqrt(X_1*X_1+Y_1*Y_1)*2/amplitud_ref;
    }

    double fase_lockin(long long X, long long Y,int div){
        long double X_1= X/div;
        long double Y_1= Y/div;
        return (atan(Y_1/X_1))*180/3.1415;
    }
};