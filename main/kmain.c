#include <nose/vga.h>


void kmain()
{
	set_vga_xy(40,12);
	printk("Loading nOSe...\0");
	for (;;);
}
