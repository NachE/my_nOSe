ENTRY(start)
SECTIONS
{
	.multiboot 0x100000: {
		multiboot = .;
		*(.multiboot)
	}

	.text : {
		kernel_start = .;
		*(.text)
		. = ALIGN(4096);
	}

	.data : {
		data = .;
		*(.data)
		*(.rodata)
		. = ALIGN(4096);
	}

	.bss : {
		bss = .;
		*(.bss)
		. = ALIGN(4096);
	}

	kernel_end = .;
}
