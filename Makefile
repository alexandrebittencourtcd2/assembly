ASM = nasm
AFLAGS = -f elf32
LD = ld
LDFLAGS = -m elf_i386
SRC = src
BIN = bin

all: $(BIN)/main

$(BIN)/main: $(SRC)/main.asm $(SRC)/math.asm $(SRC)/string.asm $(SRC)/io.asm
	@mkdir -p $(BIN)
	$(ASM) $(AFLAGS) -I$(SRC)/ $(SRC)/main.asm -o $(BIN)/main.o
	$(LD) $(LDFLAGS) $(BIN)/main.o -o $(BIN)/main

run: all
	$(BIN)/main

clean:
	rm -rf $(BIN)
