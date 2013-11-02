#define COLOR_VGA_ADDR 0xb8000
#define MONOC_VGA_ADDR 0xb0000
#define MAX_VGA_COLS 80
#define MAX_VGA_ROWS 25

unsigned short *printk(char str[]);
unsigned short *set_vga_xy(unsigned int x, unsigned int y);
