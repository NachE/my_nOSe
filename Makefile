ifeq ($(OS),Windows_NT)
	CC = i586-elf-gcc
	LD = i586-elf-ld
else
	CC = gcc
	LD = ld
endif

SOURCES = $(shell find boot main -name '*.[cs]')
OBJS = $(addsuffix .o,$(basename $(SOURCES)))

CFLAGS=-Wall -Wextra -O -m32 -c -ffreestanding -nostdinc -nostdlib -fno-builtin -fno-stack-protector -Iinclude
LDFLAGS=-melf_i386 -Tld/link.ld
ASFLAGS=-f elf32

all: $(OBJS)
	$(LD) $(LDFLAGS) -o knOSe $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.s
	nasm $(ASFLAGS) $^ 

clean:
	rm $(OBJS)
	rm knOSe
        
.PHONY: clean
