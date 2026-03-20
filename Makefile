CC = gcc
AS = nasm
LD = ld

CFLAGS = -m32 -ffreestanding -c -nostdlib
LDFLAGS = -m elf_i386 -T kernel/arch/x86/linker.ld

BUILD = build

all: kernel

$(BUILD):
	mkdir -p $(BUILD)

kernel: $(BUILD)
	$(AS) kernel/arch/x86/entry.asm -f elf -o $(BUILD)/entry.o
	$(AS) kernel/arch/x86/isr.asm -f elf -o $(BUILD)/isr.o
	$(CC) $(CFLAGS) kernel/src/kernel.c -o $(BUILD)/kernel.o
	$(CC) $(CFLAGS) kernel/src/print.c -o $(BUILD)/print.o
	$(CC) $(CFLAGS) kernel/src/idt.c -o $(BUILD)/idt.o
	$(CC) $(CFLAGS) kernel/src/keyboard.c -o $(BUILD)/keyboard.o
	$(CC) $(CFLAGS) kernel/src/pic.c -o $(BUILD)/pic.o
	$(LD) $(LDFLAGS) \
	$(BUILD)/entry.o \
	$(BUILD)/isr.o \
	$(BUILD)/kernel.o \
	$(BUILD)/print.o \
	$(BUILD)/idt.o \
	$(BUILD)/keyboard.o \
	$(BUILD)/pic.o \
	-o $(BUILD)/kernel.bin

clean:
	rm -rf $(BUILD)
