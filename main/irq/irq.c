#include <nose/vga.h>
#include <nose/irq.h>

void isr_kernel_debug(){
	printk("\nisr_kernel_debug called\n\0");
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
	printk("Interrupt received\n");
	printINT(interrupt);
}

void printINT(interrupts_t interrupt)
{

	if(interrupt.error_code != 0){
		printk("With Error Code\n\0");
	}else{
		printk("NO ERRCODE\0");
	}

	/*set_vga_xy(0,0);*/
	switch(interrupt.int_number){
		case 0x00:
			printk("Division by zero\0");
			break;
		case 0x01:
			printk("Debugger\0");
			break;
		case 0x02:
			printk("NMI\0");
			break;
		case 0x03:
			printk("Breakpoint\0");
			break;
		case 0x04:
			printk("Overflow\0");
			break;
		case 0x05:
			printk("Bounds\0");
			break;
		case 0x06:
			printk("INvalid Opcode\0");
			break;
		case 0x07:
			printk("Coprocesor not available\0");
			break;
		case 0x08:
			printk("Double fault\0");
			break;
		case 0x09:
			printk("Coprocessor Segment Overrun\0");
			break;
		case 0x0A:
			printk("Invalid Task State Segment\0");
			break;
		case 0x0B:
			printk("Segment not present\0");
			break;
		case 0x0C:
			printk("Stack Fault\0");
			break;
		case 0x0D:
			printk("General Protection Fault\n\0");
			break;
		case 0x0E:
			printk("Page fault\0");
			break;
		case 0x0F:
			printk("Reserved WAT!\0");
			break;
		case 0x10:
			printk("Math Fault\0");
			break;
		case 0x11:
			printk("Alignment Check\0");
			break;
		case 0x12:
			printk("Machine Check\0");
			break;
		case 0x13:
			printk("SIMD FLoating-Point Exception\0");
			break;
		default:
			printk("Unknown INT\0");

	}
}

