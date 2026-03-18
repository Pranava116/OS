#include "print.h"
#include "idt.h"
#include "pic.h"

void kernel_main() {
    clear_screen();
    pic_remap();
    idt_init();
    asm volatile("sti");
    while (1) {}
}