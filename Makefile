all: boot.bin

bochs:
	bochs -f bochsrc.txt -q

qemu_gdb: clean boot.bin
	qemu-system-i386 -s -S mbr.bin

qemu: clean boot.bin
	qemu-system-i386.exe mbr.bin

boot.bin: mbr.bin stage2.bin
boot: mbr stage2
boot.o: mbr.o stage2.o

stage2.bin: stage2
	objcopy -O binary stage2 stage2.bin

mbr.bin: mbr
	objcopy -O binary mbr mbr.bin

stage2: stage2.o
	ld -Tboot.ld -o stage2 stage2.o

mbr: mbr.o
	ld -Tboot.ld -o mbr mbr.o

stage2.o:
	as -o stage2.o stage2.asm

mbr.o:
	as -o mbr.o mbr.asm

clean:
	rm mbr.o mbr.bin mbr stage2.o stage2.bin stage2
