SOURCES = $(shell find boot main -name '*.[cs]')
OBJS = $(addsuffix .o,$(basename $(SOURCES)))

CFLAGS=-Wall -Wextra -O -m32 -c -ffreestanding -nostdinc -nostdlib -fno-builtin -fno-stack-protector -Iinclude
LDFLAGS=-melf_i386 -Tld/link.ld
ASFLAGS=-f elf32

all: $(OBJS)
	ld $(LDFLAGS) -o knOSe $^

%.o: %.c
	gcc $(CFLAGS) -o $@ $^

%.o: %.s
	nasm $(ASFLAGS) $^ 

clean:
	rm $(OBJS)
	rm knOSe
        
.PHONY: clean
