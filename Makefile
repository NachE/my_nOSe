SOURCES = $(shell find boot main -name '*.[cs]')
OBJS = $(addsuffix .o,$(basename $(SOURCES)))

CFLAGS=-Wall -Wextra -O -m32 -c -ffreestanding -nostdinc -nostdlib -fno-builtin -fno-stack-protector -Iinclude
LDFLAGS=-Tlink.ld
ASFLAGS=-f aout

all: $(OBJS)
	ld $(LDFLAGS) -o knOSe $^

%.o: %.c
	gcc $(CFLAGS) -o $@ $^

%.o: %.s
	nasm $(ASFLAGS) $^ 

clean:
	rm $(OBJS)
        
.PHONY: clean
