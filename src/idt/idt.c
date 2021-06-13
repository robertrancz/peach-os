#include "idt.h"
#include "../config.h"
#include "../kernel.h"
#include "memory/memory.h"
#include "io/io.h"

struct idt_desc idt_descriptors[PEACHOS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;

// Implemented in idt.asm
extern void idt_load(struct idtr_desc* ptr);
extern void int21h();
extern void no_interrupt();

void int21h_handler()
{
    print("Keyboard pressed\n");
    outb(0x20, 0x20);
}

void no_interrupt_handler()
{

}

void idt_zero()
{
    print("Divide by zero error\n");
}

void idt_set(int interrupt_no, void* address)
{
    struct idt_desc* desc = &idt_descriptors[interrupt_no];
    desc->offset_1 = (uint32_t)address & 0x0000FFFF;
    desc->selector = KERNEL_CODE_SELECTOR;
    desc->zero = 0x00;
    desc->type_attr = 0xEE; // OxE -> set type to 80386 32-bit interrupt gate; the other 0xE sets S, DPL and P
    desc->offset_2 = (uint32_t)address >> 16;
}

void idt_init()
{
    memset(idt_descriptors, 0, sizeof(idt_descriptors));
    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptor.base = (uint32_t)idt_descriptors;

    for (int i = 0; i < PEACHOS_TOTAL_INTERRUPTS; i++)
    {
        idt_set(i, no_interrupt);
    }
    

    idt_set(0, idt_zero);
    idt_set(0x21, int21h);

    // Load the Interrupt Descriptor Table
    idt_load(&idtr_descriptor);
}