#include <nose/vga.h>

unsigned short *printk(char str[], unsigned short *pos){

	unsigned int i;

        for (i = 0; str[i]; i++){
                /*0x0A = fg << 8 = bg*/
                *pos++ = str[i] | (0x0A << 8);
        }

	return pos;
}
