.code16
.global _start

# radare2 command:
# r2 -b 16 -m 0x7c00 boot.vhd

# qemu conver to raw (img) format:
# qemu-img convert -f vpc -O raw boot.vhd boot.raw

# 13h extensions should be

_start:
    cli
    xor %ax, %ax               	  # 0 AX
    mov %ax, %ds                  # Set Data Segment to 0
    mov %ax, %es                  # Set Extra Segment to 0
    mov %ax, %ss                  # Set Stack Segment to 0
    mov $0x7C00, %sp              # Set Stack Pointer to 0x7C00

    # Read sector(s) into memory
    movb $0x42, %ah
    movw $disk_address_packet, %si

    int $0x13
    nop
    hlt
    jmp .

disk_address_packet:
	packet_size: .byte 0x10
	reserved: .byte 0
	blocks: .2byte 1
	buffer: .4byte 0x7E00
	start: .quad 0x200

.fill 436-(.-_start), 1, 0

UID: .4byte 0
reserved_mbr: .2byte 0
PT1: .space 16, 0
PT2: .space 16, 0
PT3: .space 16, 0
PT4: .space 16, 0

.word 0xaa55
