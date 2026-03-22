#include "command.h"
#include "print.h"
#include "lib.h"

void execute_command(char* command) {
    if (strcmp(command, "help") == 0) {
        print("Available: help, clear, version, echo\n");
    } else if (strcmp(command, "clear") == 0) {
        clear_screen();
    } else if (strcmp(command, "version") == 0) {
        print("potatOS v0.1\n");
    } else if (strncmp(command, "echo ", 5) == 0) {
        print(command + 5);
        print("\n");
    } else {
        print("Invalid Command: ");
        print(command);
        print("\n");
    }
}
