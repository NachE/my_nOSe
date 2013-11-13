; DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
; Version 2, December 2004
;
; Copyright (C) 2013 J.A Nache <nache.nache@gmail.com>
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
; DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
; TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
; 0. You just DO WHAT THE FUCK YOU WANT TO.

;*************** IDT ****************
extern gdtCS
extern gdtDS
extern gdtuCS
extern gdtuDS
extern isr_kernel
global load_idt

load_idt:
	lidt	[idtr]
	ret

%macro ISRX 1
	global isr%1
	isr%1:
		cli
		push byte 0
		push byte %1 ; interrupt number
		jmp call_isr_kernel
%endmacro

%macro ISRX_WITHECODE 1
	global isr%1
	isr%1:
		cli
		push byte %1
		jmp call_isr_kernel
%endmacro

ISRX 0   ; Divide error
ISRX 1   ; Debug
ISRX 2   ; NMI INterrupt
ISRX 3   ; Breakpoint
ISRX 4   ; Overflow
ISRX 5   ; BOund range Exceeded
ISRX 6   ; Invalid Opcode (undefined Opcode)
ISRX 7   ; Device Not Available No Math Coprocessor
ISRX_WITHECODE 8   ; Doble Fault
ISRX 9   ; Coprocessor Segment overrun (reserved)
ISRX_WITHECODE 10  ; INvalid TSS
ISRX_WITHECODE 11  ; Segment Not PResent
ISRX_WITHECODE 12  ; Stack Segment fault
ISRX_WITHECODE 13  ; General Protection
ISRX_WITHECODE 14  ; Page Fault
ISRX 15  ; Reserved
ISRX 16  ; FLoating Point Error Math Fault
ISRX 17  ; Alignment Check
ISRX 18  ; Machine Check
ISRX 19  ; SIMD FLoating Point Exception
; Reserved:
ISRX 20  ;
ISRX 21  ;
ISRX 22  ;
ISRX 23  ;
ISRX 24  ;
ISRX 25  ;
ISRX 26  ;
ISRX 27  ;
ISRX 28  ;
ISRX 29  ;
ISRX 30  ;
ISRX 31  ;
; 32-255 ; Maskable interrupts

%macro IDTX 1
        idt%1:
		dw	((isr%1-$$ + 0x000000) & 0xFFFF) ; low part of function offset
		dw	0x08                ; selector, CS is at 0x08
		db	0x00                  ; unused
		;	                      ;      P DPL S Type <--- sure????
		db	10001110b             ; attr 1 00  0 1110
		dw	((isr%1-$$ + 0x000000) >> 16) & 0xFFFF ; hight part of function offset
%endmacro

idt:
	IDTX 0
	IDTX 1
	IDTX 2
	IDTX 3
	IDTX 4
	IDTX 5
	IDTX 6
	IDTX 7
	IDTX 8
	IDTX 9
	IDTX 10
	IDTX 11
	IDTX 12
	IDTX 13
	IDTX 14
	IDTX 15
	IDTX 16
	IDTX 17
	IDTX 18
	IDTX 19
	IDTX 20
	IDTX 21
	IDTX 22
	IDTX 23
	IDTX 24
	IDTX 25
	IDTX 26
	IDTX 27
	IDTX 28
	IDTX 29
	IDTX 30
	IDTX 31
idt_end:
idtr:
	dw	idt_end - idt - 1
	dd	idt

call_isr_kernel:
	pusha
	mov ax, ds
	push eax
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	call isr_kernel
	pop eax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	popa
	add esp, 8
	sti
	iret

; Maybe bss section and define kernel stack size here?
