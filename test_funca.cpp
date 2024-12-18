#include "funca.h"
#include <cassert>
#include <iostream>
#include <vector>
#include <chrono>
#include <algorithm>

void test_FuncA() {
    FuncAClass funca;
    assert(funca.FuncA(1, 0.0) == 0.0);
    assert(funca.FuncA(1, 1.0) != 0.0);
    std::cout << "Basic tests passed!\n";
}

void test_FuncA_performance() {
    auto t1 = std::chrono::high_resolution_clock::now();

    FuncAClass funca;
    std::vector<double> funcValues;
    funcValues.reserve(2000000);

    // Generate values using FuncA
    for (int i = 0; i < 2000000; i++) {
        double x = i * 0.001;
        funcValues.push_back(funca.FuncA(5, x));
    }

    // Sort multiple times
    for (int i = 0; i < 500; i++) {
        std::sort(begin(funcValues), end(funcValues));
    }

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count();

    std::cout << "Performance test completed in " << duration << "ms\n";
    
    // Verify 5-20 second runtime
    assert(duration >= 5000 && duration <= 20000);
}

int main() {
    test_FuncA();
    test_FuncA_performance();
    return 0;
}