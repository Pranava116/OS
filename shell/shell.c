#include "shell.h"

void shell_main() {
    char input[100];

    while (1) {
        print("[potatOS] --> ");              
        read_line(input);         
        execute_command(input);  
    }
}
