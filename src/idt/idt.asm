section .asm

extern int21h_handler
extern no_interrupt_handler

global idt_load
global int21h
global no_interrupt

idt_load:
    push ebp
    mov ebp, esp

    ; Start processing the extern idt_load() C function
    mov ebx, [ebp+8]    ; points to the first argument of the C function
    lidt [ebx]          ; load Interrupt Descriptor Table
    ; End  processing the C function

    pop ebp
    ret

; Keyboard interrupt handler
int21h:
    cli
    pushad    
    call int21h_handler
    popad
    sti
    iret

no_interrupt:
    cli
    pushad    
    call no_interrupt_handler
    popad
    sti
    iret
