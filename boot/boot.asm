bits 16
org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [boot_drive], dl

    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    mov bx, 0x7E00
    int 0x13
    jc disk_error

    jmp 0x0000:0x7E00

disk_error:
    mov si, err_msg
    call print16
    jmp $

print16:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print16
.done:
    ret

boot_drive db 0
err_msg    db "Disk error", 0

times 510 - ($ - $$) db 0
dw 0xAA55
