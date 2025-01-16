#
# Prints character string in SI register
#
.code16

print_string:
    pusha               # Save general registers
loop_print_string:
    movb $0x0e, %ah     # int 0x10/ ah 0x0e BIOS teletype output

    lodsb               # load byte from si into al and increase pointer
    cmpb $0, %al
    je end_print        # if (al == 0) end_print

    int $0x10           # print character in al

    jmp loop_print_string
end_print:
    popa
    ret
