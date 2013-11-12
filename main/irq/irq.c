#include <nose/vga.h>
#include <nose/irq.h>


void isr_kernel(interrupts_t interrupt){
	printk("\n:(\n\0");
	printk("\nInterrupt received\0");
}
