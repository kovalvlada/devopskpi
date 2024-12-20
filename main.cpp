#include <iostream>
#include "funca.h"
#include <sys/wait.h>
#include "HTTP_Server.h"

void sigchldHandler(int s) {
    printf("SIGCHLD received\n");
    pid_t pid;
    int status;

    while((pid = waitpid(-1, &status, WNOHANG)) > 0);
    {
        if (WIFEXITED(status)) {
            printf("Child %d terminated with status: %d\n", pid, WEXITSTATUS(status));
        } else {
            printf("Child %d terminated abnormally\n", pid);
        }
    }
}

void siginHandler(int s) {
    printf("Caught signal %d\n", s);
    pid_t pid;
    int status;
    while((pid = waitpid(-1, &status, 0)) > 0);
    {
        if (WIFEXITED(status)) {
            printf("Child %d terminated with status: %d\n", pid, WEXITSTATUS(status));
        } else {
            printf("Child %d terminated abnormally\n", pid);
        }
        if (pid == -1) {
            printf("No more child processes\n");
        }
    }
}

int main() {
    signal(SIGCHLD, sigchldHandler);
    signal(SIGINT, siginHandler);
    FuncAClass funca;
    std::cout << "Starting HTTP server on port 8081..." << std::endl;
    CreateHTTPserver();
    return 0;
}