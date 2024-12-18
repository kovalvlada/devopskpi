#include "funca.h"
#include <cmath>  // For pow and factorial

// Helper function to calculate factorial
long long factorial(int number) {
    long long result = 1;
    for (int i = 2; i <= number; ++i) {
        result *= i;
    }
    return result;
}

double FuncAClass::FuncA(int n, double x) {
    double result = 0.0;

    for (int i = 0; i < n; ++i) {
        double term = pow(-1, i) * pow(x, 2 * i + 1) / factorial(2 * i + 1);
        result += term;
    }

    return result;
}
