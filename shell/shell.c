#include "shell.h"
#include "print.h"
#include "input.h"
#include "command.h"

void shell_main(){
    clear_screen();
    print("Welcome to potatOS Shell\n");
    print("Type 'help' to see commands.\n\n");

    char input[100];
    while (1) {
        print("potatOS> ");
        read_line(input);
        execute_command(input);
    }
}
