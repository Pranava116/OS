#include "print.h"

static int cursor = 0;
static int cols = 80;
static int rows = 25;
static int color = 0x07;

void scroll() {
    char* video = (char*) 0xb8000;

    for (int i = 0; i < (rows - 1) * cols; i++) {
        video[i * 2]     = video[(i + cols) * 2];
        video[i * 2 + 1] = video[(i + cols) * 2 + 1];
    }

    for (int i = (rows - 1) * cols; i < rows * cols; i++) {
        video[i * 2]     = ' ';
        video[i * 2 + 1] = color;
    }

    cursor -= cols;
}

void print(const char *str) {
    char *video = (char *) 0xb8000;
    int i = 0;

    while (str[i]) {
        if (str[i] == '\n') {
            cursor = (cursor / cols + 1) * cols;
        } else {
            video[cursor * 2]     = str[i];
            video[cursor * 2 + 1] = color;
            cursor++;
        }

        if (cursor >= cols * rows) scroll();

        i++;
    }
}

void clear_screen() {
    char* video = (char*) 0xb8000;

    for (int i = 0; i < cols * rows; i++) {
        video[i * 2]     = ' ';
        video[i * 2 + 1] = color;
    }

    cursor = 0;
}
