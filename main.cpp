#include <iostream>
#include "funca.h"
#include "HTTP_Server.h"

int main() {
    FuncAClass funca;
    std::cout << "Starting HTTP server on port 8081..." << std::endl;
    CreateHTTPserver();
    return 0;
}