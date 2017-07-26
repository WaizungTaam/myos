    org 0x7c00

    mov [drive_num], dl
    mov sp, 0x9000
    call load_kernel
    jmp goto_pm


[bits 16]

load_kernel:
    mov ax, 0
    mov es, ax
    mov ah, 0x02
    mov al, 8
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [drive_num]    
    mov bx, kernel_offset
    int 0x13
    ret


goto_pm:
    cli

    lgdt [gdt_desc]

    in al, 0x92
    or al, 2
    out 0x92, al

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp sel_code:init_pm


[bits 32]

init_pm:
    mov ax, sel_data
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, 0x90000
    mov esp, eax

    call kernel_offset

    jmp $


gdt:
desc_null:
    dd 0, 0
desc_code: 
    dw 0xffff, 0
    db 0, 10011010b, 11001111b, 0
desc_data:
    dw 0xffff, 0
    db 0, 10010010b, 11001111b, 0

gdt_desc:
    dw $ - gdt - 1
    dd gdt

    sel_code equ desc_code - gdt
    sel_data equ desc_data - gdt


    kernel_offset equ 0x1000
    drive_num db 0


    times 510 - ($ - $$) db 0
    dw 0xaa55

