org 0x0
bits 16

jump main


Print:
      lodsb
      or al, al
      mov ah, 0eh
      int 10h
      jmp Print
PrintDone:
      ret

main:
      cli
      push cs
      pop ds
      mov si,Msg
      call Print
      cli hlt


Msg db "Preparing to load the operating system.....",13,10,0
