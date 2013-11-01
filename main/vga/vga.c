#include <nose/vga.h>

/*
 0xB8000 Char in position 0
 0xB8001 Options
 0xB8002 Char in position 1
*/

unsigned short *pos = (unsigned short *) COLOR_VGA_ADDR;

unsigned short *printk(char str[]){

	unsigned int i;

        for (i = 0; str[i]; i++){
                /*0x0A = fg << 8 = bg*/
                *pos++ = str[i] | (0x0A << 8);
        }
	
	return pos;
}
