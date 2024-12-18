#include "funca.h"
#include <cmath>

double FuncAClass::FuncA(int n, double x) {
    int terms = 3;  // Fixed to the first 3 terms
    double result = 0.0;

    for (int i = 0; i < terms; ++i) {
        double term = pow(-1, i) * pow(x, 2 * i + 1) / factorial(2 * i + 1);
        result += term;
    }

    return result;
}
