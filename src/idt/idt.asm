section .asm

global idt_load
idt_load:
    push ebp
    mov ebp, esp

    ; Start processing the extern idt_load() C function
    mov ebx, [ebp+8]    ; points to the first argument of the C function
    lidt [ebx]          ; load Interrupt Descriptor Table
    ; End  processing the C function

    pop ebp
    ret