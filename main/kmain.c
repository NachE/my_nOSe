#include <nose/vga.h>


void kmain()
{
	printk("Loading n0Se...\0");
	set_vga_xy(40,12);
	printk("Set VGA position test.\0");
	printk("\nReturn test.\0");
	for (;;);
}
