#include "funca.h"
#include <cassert>
#include <iostream>

void test_FuncA() {
    FuncAClass funca;

    assert(funca.FuncA(1, 0.0) == 0.0);
    assert(funca.FuncA(1, 1.0) != 0.0);  // Basic check for non-zero input
    std::cout << "All tests passed!\n";
}

int main() {
    test_FuncA();
    return 0;
}
