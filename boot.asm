ORG 0x7c00
BITS 16

start:
    mov si, message ; move the address of the message label into the si register
    call print
    jmp $   ; jump to itself (prevent further execution)

print:
    mov bx, 0
.loop:
    lodsb   
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    ; calling bios routine to show a character on the screen
    ; For details see http://www.ctyme.com/intr/rb-0106.htm
    mov ah, 0eh    
    int 0x10        ; Int10/ah=0eh - video teletype output
    ret

message: db 'Hello world!', 0

times 510-($ - $$) db 0     ; fill at least 510 bytes of data
dw 0xAA55       ; little endian (low-order byte is stored on the starting address) -> this will be 0x55AA
