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


#define COLOR_VGA_ADDR 0xb8000
#define MONOC_VGA_ADDR 0xb0000
#define MAX_VGA_COLS 80
#define MAX_VGA_ROWS 25

unsigned char *put_char(char c);
unsigned char *printk(const char *str);
unsigned char *printk_int(unsigned int n);
unsigned char *set_vga_xy(unsigned int x, unsigned int y);

