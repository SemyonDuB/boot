.code16
.global _start

# radare2 command:
# r2 -b 16 -m 0x7c00 boot.vhd

# qemu conver to raw (img) format:
# qemu-img convert -f vpc -O raw boot.vhd boot.raw

_start:
    cli
    xor %ax, %ax               	  # 0 AX
    mov %ax, %ds                  # Set Data Segment to 0
    mov %ax, %es                  # Set Extra Segment to 0
    mov %ax, %ss                  # Set Stack Segment to 0
    mov $0x7C00, %sp              # Set Stack Pointer to 0x7C00

	# Save drive number in memory
	mov %dx, drive_number

    mov $msg, %si
    call print_string

    # DISK - RESET DISK SYSTEM
    movb $0x00, %ah
    int $0x13

    # Read sector(s) into memory
    movb $0x02, %ah
    movb $1, %al        		  # number of sectors to read (must be nonzero)
    movb $0x00, %ch     		  # low eight bits of cylinder number
    movb $0x02, %cl     		  # sector number 1-63 (bits 0-5)
                        		  # high two bits of cylinder (bits 6-7, hard disk only)
    movb $0x00, %dh 			  # head number
	movb drive_number, %dl

	mov $0x7E00, %bx
    int $0x13

    mov $0x7E00, %ax
    jmp %ax
	
    nop
    hlt
    jmp .

    .include "print_string.asm"
    .include "print_hex.asm"

msg: .asciz "stage0\n\r"
drive_number: .byte 0

.fill 440-(.-_start), 1, 0

UID: .4byte 0
reserved_mbr: .2byte 0
PT1: .space 16, 0
PT2: .space 16, 0
PT3: .space 16, 0
PT4: .space 16, 0

.word 0xaa55
