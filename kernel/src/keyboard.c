#include "keyboard.h"

#define BUFFER_SIZE 256

static char buffer[BUFFER_SIZE];
static int head = 0;
static int tail = 0;

static char scancode_map[128] = {
    0,  27, '1','2','3','4','5','6','7','8','9','0','-','=', '\b',
    '\t',
    'q','w','e','r','t','y','u','i','o','p','[',']','\n',
    0,
    'a','s','d','f','g','h','j','k','l',';','\'','`',
    0,
    '\\',
    'z','x','c','v','b','n','m',',','.','/',
    0,
    '*',
    0,
    ' ',
};

void keyboard_handler() {
    unsigned char scancode;
    asm volatile("inb %1, %0" : "=a"(scancode) : "Nd"(0x60));

    if (scancode & 0x80) return;

    char c = scancode_map[scancode];
    if (c) {
        int next = (head + 1) % BUFFER_SIZE;
        if (next != tail) {
            buffer[head] = c;
            head = next;
        }
    }
}

char get_char() {
    while (tail == head){
        asm volatile("hlt");
    }
    char c = buffer[tail];
    tail = (tail + 1) % BUFFER_SIZE;
    return c;
}
    