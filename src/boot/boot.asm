ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; Reserve 33 bytes for BIOS Parameter Block (BPM) to avoid damaging code by some bioses
; For details see https://wiki.osdev.org/FAT
_start:
    jmp short start
    nop
times 33 db 0

start:
    jmp 0:step2     ; set the code segment to 0

step2:
    cli     ; clear interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax    
    mov ss, ax
    mov sp, 0x7c00
    sti     ; enable interrupts    
    
load_protected:
    cli
    lgdt[gdt_descriptor]    ; load GDT
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32


; GDT https://wiki.osdev.org/Global_Descriptor_Table
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

; offset 0x8
gdt_code:       ; CS should point to this
    dw 0xffff   ; Segment limit first 0-15 bits
    dw 0        ; Base first 0-15 bits
    db 0        ; Base 16-23 bits
    db 0x9a     ; Access bytes
    db 11001111b ; High 4 bit flags and low 4 bit flags
    db 0        ; Base 24-31 bits

; offset 0x10
gdt_data:       ; DS, SS, ES, FS, GS should point to this
    dw 0xffff   ; Segment limit first 0-15 bits
    dw 0        ; Base first 0-15 bits
    db 0        ; Base 16-23 bits
    db 0x92     ; Access bytes
    db 11001111b ; High 4 bit flags and low 4 bit flags
    db 0        ; Base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; size of the descriptor
    dd gdt_start                ; offset

; Load the kernel into memory and jump to it
[BITS 32]
load32:
    mov eax, 1          ; starting sector is 1 because 0 is the boot sector
    mov ecx, 100        ; total no of sectors we want to load
    mov edi, 0x0100000  ; the address to load into
    call ata_lba_read
    jmp CODE_SEG:0x0100000

; Dummy driver to get the kernel loaded
ata_lba_read:
    mov ebx, eax        ; Backup the LBA
    ; Send the highest 8 bits of the LBA to hard disk controller
    shr eax, 24
    or eax, 0xE0        ; Select the master drive
    mov dx, 0x1F6
    out dx, al
    ; Finished sending highest 8 bits to the LBA
    
    ; Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al
    ; Finished sending the total sectors to read

    ; Send more bits of the LBA
    mov eax, ebx        ; Restore the backup LBA
    mov dx, 0x1F3
    out dx, al
    ; Finished sending more bits of the LBA

    ; Send more bits of the LBA
    mov dx, 0x1F4
    mov eax, ebx        ; Restore the backup LBA
    shr eax, 8
    out dx, al
    ; Finished sending more bits of the LBA

    ; Send upper 16 bits of the LBA
    mov dx, 0x1F5
    mov eax, ebx        ; Restore the backup LBA
    shr eax, 16
    out dx, al
    ; Finished sending upper 16 bits of the LBA

    mov dx, 0x1F7
    mov al, 0x20
    out dx, al

; Read all sectors into memory
.next_sector:
    push ecx

; Checking if we need to read
.try_again:
    mov dx, 0x1F7
    in al, dx
    test al, 8
    jz .try_again

    ; We need to read 256 words at a time (256 words = 512 bytes = 1 sector)
    mov ecx, 256
    mov dx, 0x1F0
    rep insw        ; https://faydoc.tripod.com/cpu/insw.htm
    pop ecx
    loop .next_sector
    ; End of reading sectors into memory
    ret

times 510-($ - $$) db 0     ; fill at least 510 bytes of data
dw 0xAA55       ; little endian (low-order byte is stored on the starting address) -> this will be 0x55AA
