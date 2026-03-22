#include "print.h"
#include "idt.h"
#include "pic.h"
#include "boot_info.h"

static void print_hex(uint32_t val) {
    char buf[11];
    const char *hex = "0123456789ABCDEF";
    buf[0] = '0'; buf[1] = 'x';
    for (int i = 9; i >= 2; i--) {
        buf[i] = hex[val & 0xF];
        val >>= 4;
    }
    buf[10] = '\0';
    print(buf);
}

void kernel_main(boot_info_t *boot) {
    clear_screen();

    if (!boot || boot->magic != BOOT_MAGIC) {
        print("PANIC: invalid boot_info magic!\n");
        while (1) {}
    }

    print("potatOS booting...\n");
    print("Boot info received. Magic: ");
    print_hex(boot->magic);
    print("\n");

    e820_entry_t *entries = (e820_entry_t *)(uint32_t)boot->entries_addr;
    print("Memory map entries: ");
    print_hex(boot->entry_count);
    print("\n");

    for (uint32_t i = 0; i < boot->entry_count; i++) {
        if (entries[i].type == 1) {
            print("  [USABLE] base=");
            print_hex((uint32_t)entries[i].base);
            print(" len=");
            print_hex((uint32_t)entries[i].length);
            print("\n");
        }
    }

    pic_remap();
    idt_init();
    asm volatile("sti");

    while (1) {}
}
