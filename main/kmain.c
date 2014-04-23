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
#include <nose/irq.h>
extern void debug_idt();

void kmain()
{
	set_vga_xy(40,12);
	printk("Welcome to nOSe");
	/*asm volatile("int $0x12");*/
	for (;;);
}
