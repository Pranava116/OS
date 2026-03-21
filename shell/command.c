#include "../kernel/src/print.h"
#include <string.h> 

void execute_command(char* command) {
  if (strcmp(command, "help") == 0){
    print("Available: help, clear, version\n");
  } else if (strcmp(command, "clear") == 0){
    clear_screen();
  } else if(strcmp(command, "verison") == 0){
    print("potatOS -v 101");
  }else {
    print("Invalid Command: ");
    print(command);
    print("\n");
  }
}