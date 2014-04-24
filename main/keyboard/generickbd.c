/*
 *   generickbd.c
 *
 *   This file is part of nOSe.
 *
 *   Copyright (C) 2014 J.A Nache <nache.nache@gmail.com>
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
#include <nose/irq.h>
#include <nose/vga.h>
#include "generickbd.h"

/*http://www.ee.bgu.ac.il/~microlab/MicroLab/Labs/ScanCodes.htm*/
char scancodes[] = "\0*1234567890-=*\tqwertyuiop{}\n*asdfghjkl:'~*\\zxcvbnm,./*** ********************";

void install_generickbd(){
	install_irq(0x21, generickbd_main);
}

void generickbd_main(interrupts_t regs)
{
	char scancode;
	scancode = inportb1(0x60);
	if(scancode & 0x80){
	}else{
		put_char(scancodes[(int)scancode]);
	}
}
