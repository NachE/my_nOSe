#include <nose/vga.h>
#include <nose/irq.h>


void isr_kernel(interrupts_t interrupt){
	printk("Interrupt received\0");
}
