/*
 *   kmain.c
 * 
 *   This file is part of nOSe.
 *
 *   nOSe is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   nOSe is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with nOSe.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <nose/vga.h>

extern void reload_gdt();
extern void load_idt();

void kmain()
{
	printk("Reloading GDT...\n\0");
	reload_gdt();
	printk("Loading IDT...\n\0");
	load_idt();
	set_vga_xy(40,12);
	printk("Set VGA position test.\n\0");
	/*test irq*/
	asm volatile ("int $0x01"); 
	for (;;);
}
