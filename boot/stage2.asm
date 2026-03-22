bits 16
org 0x7E00

stage2_start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov di, 0x8000
    xor ebx, ebx
    xor bp, bp

.e820_loop:
    mov eax, 0xE820
    mov ecx, 24
    mov edx, 0x534D4150
    int 0x15
    jc .e820_done

    cmp eax, 0x534D4150
    jne .e820_done

    test ecx, ecx
    jz .e820_next

    inc bp
    add di, 20

.e820_next:
    test ebx, ebx
    jz .e820_done
    jmp .e820_loop

.e820_done:
    mov [e820_count], bp

    mov dword [0x9000], 0xCAFEBABE
    movzx eax, word [e820_count]
    mov dword [0x9004], eax
    mov dword [0x9008], 0x8000

    lgdt [gdt_descriptor]

    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode

gdt_start:
    dq 0

gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

e820_count dw 0

bits 32
protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    mov eax, 0x9000

    jmp 0x08:0x100000

    cli
    hlt
