#include "shell.h"

void shell_main() {
    char input[100];
    printf("--potatOS--")

    while (1) {
        printf("[potatOS] --> ");              
        read_line(input);  
        execute_command(input);  
    }
}