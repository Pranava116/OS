global _start
extern kernel_main

section .text
_start:
    ; EAX holds the boot_info_t* passed by the bootloader
    push eax            ; pass as first argument to kernel_main
    call kernel_main
    jmp $
