#include <nose/vga.h>
#include <nose/irq.h>



void isr_kernel_debug(){
	printk("\nisr_kernel_debug called\n\0");
}

void isr_kernel(interrupts_t interrupt){
	printk("\nInterrupt received:\n\0");
}
