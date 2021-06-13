section .asm

global insb
global insw
global outb
global outw

insb:
    push ebp
    mov ebp, esp

    ; Start processing the extern insb() C function
    xor eax, eax
    mov edx, [ebp+8]    ; points to the first argument of the C function, the port
    in al, dx
    ; End  processing the C function

    pop ebp
    ret

insw:
    push ebp
    mov ebp, esp

    ; Start processing the extern insw() C function
    xor eax, eax
    mov edx, [ebp+8]    ; points to the first argument of the C function, the port
    in ax, dx
    ; End  processing the C function

    pop ebp
    ret

outb:
    push ebp
    mov ebp, esp

    ; Start processing the extern outb() C function
    mov eax, [ebp+12]
    mov edx, [ebp+8]    ; points to the first argument of the C function, the port
    out dx, al
    ; End  processing the C function

    pop ebp
    ret

outw:
    push ebp
    mov ebp, esp

    ; Start processing the extern outw() C function
    mov eax, [ebp+12]
    mov edx, [ebp+8]    ; points to the first argument of the C function, the port
    out dx, ax
    ; End  processing the C function

    pop ebp
    ret