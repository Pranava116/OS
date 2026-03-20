global isr_keyboard
extern keyboard_handler

section .text

isr_keyboard:
    pusha

    call keyboard_handler

    mov al, 0x20
    out 0x20, al

    popa
    iret
