#include <iostream>
#include "funca.h"

int main() {
    FuncAClass funca;
    int n = 10; // Example value for n
    double x = 1.0; // Example value for x (in radians)
    std::cout << "FuncA result: " << funca.FuncA(n, x) << std::endl;
    return 0;
}