#include "idt.h"

extern void isr_keyboard();

#define IDT_SIZE 256

struct idt_entry idt[IDT_SIZE];
struct idt_ptr idtpointer;

void set_idt_gate(int n, unsigned int handler) {
    idt[n].offset_low = handler & 0xFFFF;
    idt[n].selector = 0x08;
    idt[n].zero = 0;
    idt[n].type_attr = 0x8E;
    idt[n].offset_high = (handler >> 16) & 0xFFFF;
}

void idt_init() {
    idtpointer.limit = (sizeof(struct idt_entry) * IDT_SIZE) - 1;
    idtpointer.base = (unsigned int)&idt;

    set_idt_gate(33, (unsigned int)isr_keyboard);

    asm volatile("lidt %0" : : "m"(idtpointer));
}
