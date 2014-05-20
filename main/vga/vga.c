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
#include <nose/libc/strlen.h>


/*
 0xB8000 Char in position 0
 0xB8001 Options
 0xB8002 Char in position 1
*/

unsigned short int *pos = (unsigned short int *) COLOR_VGA_ADDR;
unsigned int vga_x, vga_y = 0;
unsigned int line_count = 0;
int attrib = ((0x00 << 4) | (0x02 & 0x0F)) << 8;

void put_char(char c)
{
	if(c == '\n')
	{
		/* reset x and increment y
		 * this func correct vga_x and vga_y */
		set_vga_xy(0, vga_y+1);
	}else if(c == '\b'){
		*pos--;
		*pos-- = '\0' | (0x0A << 8);
		*pos++;
		vga_x--;
	}else{
		*pos++ = c | (0x0A << 8); /* put char on screen */
		vga_x++;
	}

	if(vga_x > 80){
		vga_x=0;
		vga_y++;
	}

	if(vga_x < 0){
		vga_x=80;
		vga_y--;
	}

	if(vga_y > 24){
		/*TODO: SCROLL SCREEN HERE*/
		set_vga_xy(0,0);
	}

	debug_cursor();
}

void debug_cursor(){
	char x = (char)( (int)'0'+vga_x );
	char y = (char)( (int)'0'+vga_y );
	unsigned short int *corner = (unsigned short int *) COLOR_VGA_ADDR;
	*corner++ = x | (0x0A << 8);
	*corner++ = 'x' | (0x0A << 8);
	*corner++ = y | (0x0A << 8);
}

void printk(char *str)
{
	while(*str != '\0'){
		put_char(*str);
		str++;
	}
}

void printk_int(unsigned int n)
{
	printk(itoa(n));
}

char *itoa(unsigned int n)
{
	char c[11]; /* 10 for numbers, 1 for \0. Use 12 for signed */
	char *str;

/*
	int m = 0;
	int i = 0;
	
	while(n > 0){
		m = n%10;

		c[i++] = (char)(m+48);

		n /=10;
	}
	
	c[i]='\0';
	
	str = &c[0];

*/

	c[0]=0x61;
	c[1]=0x62;
	c[2]=0x63;
	c[3]=0x00;
	str = &c[0];

	return str;
}

void set_vga_xy(unsigned int x, unsigned int y)
{
	unsigned int position = ( y * MAX_VGA_COLS ) + x;
	pos = (unsigned short int *) COLOR_VGA_ADDR + position;
	vga_x = x;
	vga_y = y;
}
