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
section .data
extern isr_kernel
extern isr_kernel_debug
global load_idt
global debug_idt

%macro ISRX 1
	isr%1:
		cli
		push byte 0
		push byte %1 ; interrupt number
		jmp call_isr_kernel
%endmacro

%macro ISRX_WITHECODE 1
	isr%1:
		cli
		push byte %1
		jmp call_isr_kernel
%endmacro

%macro IDTX 1
	mov	eax,isr%1		;move isr address to eax
	mov	[idt+%1*8],ax		;low part of handler address
	mov word [idt+%1*8+2],0x08	;code selector
	mov word [idt+%1*8+4],0x8E00	;attributes
	shr	eax,16			;move the hight part to eax
	mov	[idt+%1*8+6],ax		;move the hight part to idt entry
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
ISRX 32
ISRX 33
ISRX 34
ISRX 35
ISRX 36
ISRX 37
ISRX 38
ISRX 39
ISRX 40
ISRX 41
ISRX 42
ISRX 43
ISRX 44
ISRX 45
ISRX 46
ISRX 47
ISRX 48
ISRX 49
ISRX 50
ISRX 51
ISRX 52
ISRX 53

idtr:
	dw (50*8)-1
	dd idt

idt:
	resd 50*2

load_idt:
	;load idt table
        lidt    [idtr]

	;poblate idt
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
	IDTX 32
	IDTX 33
	IDTX 34
	IDTX 35
	IDTX 36
	IDTX 37
	IDTX 38
	IDTX 39
	IDTX 40
	IDTX 41
	IDTX 42
	IDTX 43
	IDTX 44
	IDTX 45
	IDTX 46
	IDTX 47
	IDTX 48
	IDTX 49
	IDTX 50
	IDTX 51
	IDTX 52
	IDTX 53
	iret

call_isr_kernel:
        pusha
        mov ax, ds
        push eax
        mov ax, 0x10
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        ;mov ss, ax
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
