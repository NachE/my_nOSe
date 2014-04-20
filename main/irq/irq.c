#include <nose/vga.h>
#include <nose/irq.h>

void divide_zero(int num){
	num = 1 / 0;
}

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
	printk("\nInterrupt received\n\0");
	printINT(interrupt.int_number);
}
