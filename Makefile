all: os

boot.bin: boot.asm
	nasm -f bin -o boot.bin boot.asm

entry.o: entry.asm
	nasm -f elf -o entry.o entry.asm

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c -o kernel.o kernel.c

kernel.bin: entry.o kernel.o
	ld -m elf_i386 -Ttext 0x1000 -o kernel.bin entry.o kernel.o --oformat binary

os: boot.bin kernel.bin
	cat boot.bin kernel.bin > os

clean:
	rm *.o *.bin os
