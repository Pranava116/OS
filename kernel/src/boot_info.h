#ifndef BOOT_INFO_H
#define BOOT_INFO_H

#include <stdint.h>

#define BOOT_MAGIC 0xCAFEBABE

typedef struct {
    uint64_t base;
    uint64_t length;
    uint32_t type;
} __attribute__((packed)) e820_entry_t;

typedef struct {
    uint32_t magic;
    uint32_t entry_count;
    uint32_t entries_addr;
} __attribute__((packed)) boot_info_t;

#endif
