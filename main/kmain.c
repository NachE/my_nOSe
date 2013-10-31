
void kmain()
{

/* unsigned short *textmemptr = (unsigned short *)0xB8000;*/
unsigned short *cursor = (unsigned short *) 0xB8000 + 0 * 80;

/*
4C L
4F O
41 A
44 D
49 I
4E N
47 G
20 
6E n
4F O
53 S
65 e
2E .
2E .
2E .
*/

*cursor++ = 0x4C | (0x0F << 9);
*cursor++ = 0x4F | (0x0F << 9);
*cursor++ = 0x41 | (0x0F << 9);
*cursor++ = 0x44 | (0x0F << 9);
*cursor++ = 0x49 | (0x0F << 9);
*cursor++ = 0x4E | (0x0F << 9);
*cursor++ = 0x47 | (0x0F << 9);
*cursor++ = 0x20 | (0x0F << 9);
*cursor++ = 0x6E | (0x0F << 9);
*cursor++ = 0x4F | (0x0F << 9);
*cursor++ = 0x53 | (0x0F << 9);
*cursor++ = 0x65 | (0x0F << 9);
*cursor++ = 0x2E | (0x0F << 9);
*cursor++ = 0x2E | (0x0F << 9);
*cursor++ = 0x2E | (0x0F << 9);

	for (;;);
}
