/*
 *   vga.c
 *
 *   This file is part of nOSe.
 *
 *   Copyright (C) 2013-2014 J.A Nache <nache.nache@gmail.com>
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
extern void eoi_irq_a();
extern void eoi_irq_b();
extern char inportb1(unsigned short int port);

void isr_kernel_debug(){
	printk("\nisr_kernel_debug called\n");
}

/*
typedef struct interrupts{
        unsigned int ds;
        unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eas;
        unsigned int int_number, error_code;
        unsigned int e_ip, cs, e_flags, user_esp, ss;
} interrupts_t;
*/

void isr_kernel(interrupts_t interrupt){
	printk("\nInterrupt received\n");
	printINT(interrupt);
}

void irq_kernel(interrupts_t interrupt){

	char scancode;

	if(interrupt.int_number == 0x21){
		
		/* read scancode from keyboard buffer*/
		scancode = inportb1(0x60);
		
		if(scancode == 0x1e){
			printk("Key a");
		}
	}

	if(interrupt.int_number >= 40){
		eoi_irq_b();
	}
	eoi_irq_a();
}

void printINT(interrupts_t interrupt)
{

	if(interrupt.error_code != 0){
		printk("With Error Code\n");
	}else{
		printk("NO ERRCODE\n");
	}

	/*set_vga_xy(0,0);*/
	switch(interrupt.int_number){
		case 0x00:
			printk("Division by zero\n");
			break;
		case 0x01:
			printk("Debugger\n");
			break;
		case 0x02:
			printk("NMI\n");
			break;
		case 0x03:
			printk("Breakpoint\n");
			break;
		case 0x04:
			printk("Overflow\n");
			break;
		case 0x05:
			printk("Bounds\n");
			break;
		case 0x06:
			printk("INvalid Opcode\n");
			break;
		case 0x07:
			printk("Coprocesor not available\n");
			break;
		case 0x08:
			printk("Double fault\n");
			break;
		case 0x09:
			printk("Coprocessor Segment Overrun\n");
			break;
		case 0x0A:
			printk("Invalid Task State Segment\n");
			break;
		case 0x0B:
			printk("Segment not present\n");
			break;
		case 0x0C:
			printk("Stack Fault\n");
			break;
		case 0x0D:
			printk("General Protection Fault\n");
			break;
		case 0x0E:
			printk("Page fault\n");
			break;
		case 0x0F:
			printk("Reserved WAT!\n");
			break;
		case 0x10:
			printk("Math Fault\n");
			break;
		case 0x11:
			printk("Alignment Check\n");
			break;
		case 0x12:
			printk("Machine Check\n");
			break;
		case 0x13:
			printk("SIMD FLoating-Point Exception\n");
			break;
		default:
			printk("Unknown INT\n");

	}
}

