ORG 0
BITS 16
_start:
    jmp short start
    nop

 times 33 db 0 ; create 33 bytes for BIOS Parameter Block

start:
    jmp 0x7c0:step2

step2:
    cli ; Clear interupts (disable interupts, critical operations)
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables interupts

    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop: ; loops until all chars are printed to screen
    lodsb ; puts current char into the al register
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh ; function for outputing to screen when talking to BIOS, takes char from al register
    int 0x10 ; BIOS interrupt
    ret
message: db 'Hello World!', 0

times 510- ($ - $$) db 0
dw 0xAA55