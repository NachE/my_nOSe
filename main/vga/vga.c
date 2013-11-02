#include <nose/vga.h>

/*
 0xB8000 Char in position 0
 0xB8001 Options
 0xB8002 Char in position 1
*/

unsigned short *pos = (unsigned short *) COLOR_VGA_ADDR;
unsigned int vga_x, vga_y = 0;

unsigned short *printk(char str[]){

	return write_vga(str);
}

unsigned short *write_vga(char str[]){

	unsigned int i;

        for (i = 0; str[i]; i++){
                /*0x0A = fg << 8 = bg*/
		/* increment x cursor*/
		vga_x++;
		/* if at the end of width */
		if(vga_x > 80){
			vga_x = 0; /* reset x to start */
			vga_y++; /* increment y cursor */
		}
		/* if return special char */
		if(str[i] == '\n'){
			set_vga_xy(0,vga_y+1); /* reset x and increment y
						* this func correct vga_x and vga_y */
		}else{ /* if none special char, write char */
			/* increment pointer, write char and attr values */
			*pos++ = str[i] | (0x0A << 8);
		}
        }
	
	return pos;
}

unsigned short *set_vga_xy(unsigned int x, unsigned int y){
	unsigned int position = ( y * MAX_VGA_COLS ) + x;
	pos = (unsigned short *) COLOR_VGA_ADDR + position;
	vga_x = x;
	vga_y = y;
	return pos;
}
