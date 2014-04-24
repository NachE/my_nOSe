

typedef struct interrupts{
	unsigned int ds;
	unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eas;
	unsigned int int_number, error_code;
	unsigned int e_ip, cs, e_flags, user_esp, ss;
} interrupts_t;

void isr_kernel_debug(void);
void isr_kernel(interrupts_t regs);
void printINT(interrupts_t interrupt);
void install_irq(unsigned int irq_num, void(*irq_func)(interrupts_t regs));
extern void eoi_irq_a();
extern void eoi_irq_b();
extern char inportb1(unsigned short int port);

