.code16
.global _start

_start:
    xor %ax, %ax
    mov %ax, %bx
    mov %dx, drive_number

    mov $msg, %si
    call print_string

    nop
    hlt
    jmp .

.include "print_string.asm"
.include "print_hex.asm"

msg: .asciz "stage1\n\r"
drive_number: .byte 0

kernel_filename: .asciz "kernel.txt"
