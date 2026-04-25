ASM = nasm
AFLAGS = -f elf32
LD = ld
LDFLAGS = -m elf_i386
SRC = src
BIN = bin

all: $(BIN)/main

SRCS = $(SRC)/main.asm $(SRC)/math.asm $(SRC)/string.asm $(SRC)/io.asm \
       $(SRC)/bits.asm $(SRC)/convert.asm $(SRC)/stack.asm \
       $(SRC)/memory.asm $(SRC)/sort.asm

$(BIN)/main: $(SRCS)
	@mkdir -p $(BIN)
	$(ASM) $(AFLAGS) -I$(SRC)/ $(SRC)/main.asm -o $(BIN)/main.o
	$(LD) $(LDFLAGS) $(BIN)/main.o -o $(BIN)/main

run: all
	$(BIN)/main

clean:
	rm -rf $(BIN)
