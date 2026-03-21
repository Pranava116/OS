#include "../shell/input.h"
#include "../kernel/src/keyboard.h"
#include "../kernel/src/print.h"

void read_line(char* buffer) {
  int i = 0;
  char c;

  while (1) {
    while ((c = get_char()) == 0);

    if (c == '\n') {
      buffer[i] = '\0';
      print("\n");
      break;
    } else if (c == '\b') {
        if (i > 0) {
          i--;
          buffer[i] = '\0';
          print("\b \b");
        }
      } else {
        buffer[i++] = c;
        char str[2] = {c, '\0'};
        print(str);
      }
    }
  }
