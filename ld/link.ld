ENTRY(start)
SECTIONS
{
	.multiboot 0x100000: {
		multiboot = .; _multiboot = .; __multiboot = .;
		*(.multiboot)
	}

	.text : {
		kernel_start = .; _kernel_start = .; __kernel_start = .;
		*(.text)
		. = ALIGN(4096);
	}

	.data : {
		data = .; _data = .; __data = .;
		*(.data)
		*(.rodata)
		. = ALIGN(4096);
	}

	.bss : {
		bss = .; _bss = .; __bss = .;
		*(.bss)
		. = ALIGN(4096);
	}

	kernel_end = .; _kernel_end = .; __kernel_end = .;
}
