#ifndef CONFIG_H
#define CONFIG_H

#define KERNEL_CODE_SELECTOR 0x08       // CODE_SEG defined in kernel.asm
#define KERNEL_DATA_SELECTOR 0x10       // DATA_SEG defined in kernel.asm

#define PEACHOS_TOTAL_INTERRUPTS 512    // 0x200

#define PEACHOS_HEAP_SIZE_BYTES 104857600   // 100MB
#define PEACHOS_HEAP_BLOCK_SIZE 4096
#define PEACHOS_HEAP_ADDRESS 0x01000000     // extended memory space - free RAM. See https://wiki.osdev.org/Memory_Map
#define PEACHOS_HEAP_TABLE_ADDRESS 0x00007E00   // Real mode address space - 480.5KiB usable memory at this address

#endif