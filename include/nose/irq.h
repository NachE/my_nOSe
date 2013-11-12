

typedef struct interrupts{
	unsigned int ds;
	unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eas;
	unsigned int int_number, error_code;
	unsigned int e_ip, cs, e_flags, user_esp, ss;
} interrupts_t;
