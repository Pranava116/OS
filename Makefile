CC = gcc
AS = nasm
LD = ld

CFLAGS  = -m32 -ffreestanding -c -nostdlib -I kernel/src -I lib -I shell
LDFLAGS = -m elf_i386 -T kernel/arch/x86/linker.ld

BUILD = build

all: $(BUILD)/os.img

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.bin: boot/boot.asm | $(BUILD)
	$(AS) $< -f bin -o $@

$(BUILD)/stage2.bin: boot/stage2.asm | $(BUILD)
	$(AS) $< -f bin -o $@

$(BUILD)/entry.o: kernel/arch/x86/entry.asm | $(BUILD)
	$(AS) $< -f elf -o $@

$(BUILD)/isr.o: kernel/arch/x86/isr.asm | $(BUILD)
	$(AS) $< -f elf -o $@

$(BUILD)/kernel.o: kernel/src/kernel.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/print.o: kernel/src/print.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/idt.o: kernel/src/idt.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/keyboard.o: kernel/src/keyboard.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/pic.o: kernel/src/pic.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/lib.o: lib/lib.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/input.o: shell/input.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/command.o: shell/command.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/shell.o: shell/shell.c | $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/kernel.bin: $(BUILD)/entry.o $(BUILD)/isr.o $(BUILD)/kernel.o \
                     $(BUILD)/print.o $(BUILD)/idt.o $(BUILD)/keyboard.o \
                     $(BUILD)/pic.o $(BUILD)/lib.o $(BUILD)/input.o \
                     $(BUILD)/command.o $(BUILD)/shell.o
	$(LD) $(LDFLAGS) $^ -o $@

$(BUILD)/os.img: $(BUILD)/boot.bin $(BUILD)/stage2.bin $(BUILD)/kernel.bin
	dd if=/dev/zero        of=$@ bs=512 count=2880 2>/dev/null
	dd if=$(BUILD)/boot.bin   of=$@ bs=512 seek=0  conv=notrunc 2>/dev/null
	dd if=$(BUILD)/stage2.bin of=$@ bs=512 seek=1  conv=notrunc 2>/dev/null
	dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=2048 conv=notrunc 2>/dev/null

run: $(BUILD)/os.img
	qemu-system-x86_64 -fda $(BUILD)/os.img

clean:
	rm -rf $(BUILD)
