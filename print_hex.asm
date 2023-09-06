#
# Print hexidecimal values using register BX and print_string.asm
#
# Ascii '0'-'9' = hex 0x30-0x39
# Ascii 'A'-'F' = hex 0x41-0x46
# Ascii 'a'-'f' = hex 0x61-0x66
#
.code16

print_hex:
    pusha                 # save all registers to the stack
    mov $0, %cx           # initialize loop counter

hex_loop:
    cmp $4, %cx           # are we at end of loop?
    je end_hexloop

    # Convert DX hex values to ascii
    mov %bx, %ax
    and $0x000F, %ax      # turn 1st 3 hex to 0, keep final digit to convert
    add $0x30, %al        # get ascii number or letter value
    cmp $0x39, %al        # is hex value 0-9 (<= 0x39) or A-F ( > 0x39)
    jle move_intoSI
    add $0x07, %al        # to get ascii 'A'-'F'

move_intoSI:
    mov $hexString + 5, %si   # base address of hexString + length of string
    sub %cx, %si             # subtract loop counter
    mov %al, (%si)
    ror $4, %bx              # rotate right by 4 bits
    add $1, %cx              # increment counter
    jmp hex_loop             # loop for next hex digit in DX

end_hexloop:
    mov $hexString, %si
    call print_string

    popa                # restore all registers from the stack
    ret                 # return to caller

    # Data
hexString: .asciz "0x0000"