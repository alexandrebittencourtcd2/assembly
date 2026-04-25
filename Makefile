all: hello calculadora

hello: hello.asm
	nasm -f elf32 hello.asm -o hello.o
	ld -m elf_i386 hello.o -o hello

calculadora: calculadora.asm
	nasm -f elf32 calculadora.asm -o calculadora.o
	ld -m elf_i386 calculadora.o -o calculadora

clean:
	rm -f *.o hello calculadora
