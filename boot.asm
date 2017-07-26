    org 0x7c00

    jmp goto_pm



[bits 16]
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

    mov ebx, 0xb8000
    mov ah, 0x0f
    mov al, 'P'
    mov [ebx], ax

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


    times 510 - ($ - $$) db 0
    dw 0xaa55

