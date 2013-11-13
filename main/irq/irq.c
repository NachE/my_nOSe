#include <nose/vga.h>
#include <nose/irq.h>


void isr_kernel(interrupts_t interrupt){
	printk("\nInterrupt received:\0");
	/* printk(interrupt.int_number); */
}
