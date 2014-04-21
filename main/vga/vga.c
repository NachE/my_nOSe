/*
 *   vga.c
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
#include <nose/libc/strlen.h>


/*
 0xB8000 Char in position 0
 0xB8001 Options
 0xB8002 Char in position 1
*/

unsigned short *pos = (unsigned short *) COLOR_VGA_ADDR;
unsigned int vga_x, vga_y = 0;
unsigned int line_count = 0;


unsigned short *put_char(char c)
{

	c = 'a'; /*TODO: FORCE USE THIS CHAR FOR DEBUG PURPOSES*/

	if(c == '\n') /*TODO: THIS DOESNT WORK */
	{
		/* reset x and increment y
		 * this func correct vga_x and vga_y */
		vga_y++;
		set_vga_xy(0,vga_y);
	}else{
		
		*pos++ = c | (0x0A << 8);
	}
	
	return pos;
}

unsigned short *printk_int(unsigned int n)
{
	/*0x0A = fg << 8 = bg*/
	*pos++ = n | (0x0A << 8); /*TODO: OBVIOUSLY THIS DOES NOT WORK*/
	return pos;
}

unsigned short *write_vga(char *str){
	return printk(str);
}

unsigned short *printk(char *str)
{
	unsigned int i = 0;
	
	for(i = 0; i < strlen(str); i++)   /* TODO: THIS APARENTLY DOESNT WORK */
	{			
		/* increment x cursor*/
		vga_x++;

		/* if at the end of width */
		if(vga_x > 80){
			vga_y++;
			set_vga_xy(0,vga_y);
		}

		if(vga_y > 25)
			set_vga_xy(0,0);
		
		put_char(str[i]);
        }
	
	return pos;
}

unsigned short *set_vga_xy(unsigned int x, unsigned int y)
{
	unsigned int position = ( y * MAX_VGA_COLS ) + x;
	pos = (unsigned short *) COLOR_VGA_ADDR + position;
	vga_x = x;
	vga_y = y;
	return pos;
}
