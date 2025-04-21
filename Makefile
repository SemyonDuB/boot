all: clean boot.bin

bochs:
	bochs -f bochsrc.txt -q

qemu_gdb: image
	qemu-system-i386 -s -S build/boot.img

qemu: image
	qemu-system-i386 build/boot.img

image: clean boot.bin
	dd if=/dev/zero of=build/boot.img bs=5M count=1
	mformat -i build/boot.img ::
	dd if=build/mbr.bin of=build/boot.img bs=446 count=1 conv=notrunc
	dd seek=1 if=build/stage2.bin of=build/boot.img conv=notrunc

boot.bin: mbr.bin stage2.bin
boot: mbr stage2
boot.o: mbr.o stage2.o

stage2.bin: stage2
	objcopy -O binary build/stage2 build/stage2.bin

mbr.bin: mbr
	objcopy -O binary build/mbr build/mbr.bin

stage2: stage2.o
	ld -Tstage2.ld -o build/stage2 build/stage2.o

mbr: mbr.o
	ld -Tboot.ld -o build/mbr build/mbr.o

stage2.o:
	as -o build/stage2.o stage2.asm

mbr.o:
	mkdir build/
	as -o build/mbr.o mbr.asm

clean:
	rm -rvf build/
