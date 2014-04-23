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

; nasm syntax: http://www.nasm.us/doc/nasmdoc3.html
; DOC:
; http://www.gnu.org/software/grub/manual/multibooti/multiboot.html
; http://download.intel.com/products/processor/manual/253668.pdf
;
; DB Define Byte (8)
; DW Define Word (16)
; DD Define Double (32)
; using intel doc manual
; http://download.intel.com/products/processor/manual/253668.pdf
; The code sample define it as struct, Im going to try with this
;	dw	; lim_0_15  16b
;	dw	; bas_0_15  16b
;	db	; ????????
;	db	; access     8b
;	db	; gran       8b
;	db	; bas_24_31  8b
;
; Intel Code on Developer's manual Volume 3A. 9-25, Pag 421.
;
; 86 DESC STRUC
; 87 lim_0_15	DW ?
; 88 bas_0_15	DW ?
; 89 bas_16_23	DB ?
; 90 access	DB ?
; 91 gran	DB ?
; 92 bas_24_31	DB ?
; 93 DESC ENDS
;
; 	From right to left:
;
;         Base                 Granularity              Access                      Base
;|                       |                       |                        |                      |
; 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
;  ^                    ^  ^  ^  ^  ^  ^        ^  ^  ^  ^  ^  ^        ^  ^                    ^
;  |                    |  |  |  |  |  |        |  |  |__|  |  |        |  |                    |
;  |____________________|  |  |  |  |  |        |  |    |   |  |        |  |                    |___ Base start
;           |              |  |  |  |  |        |  |    |   |  |        |  |________________________ Base end
;           |              |  |  |  |  |        |  |    |   |  |        |
;           |              |  |  |  |  |        |  |    |   |  |        |___________________________ Type start
;           |              |  |  |  |  |        |  |    |   |  |____________________________________ Type end
;           |              |  |  |  |  |        |  |    |   |    
;           |              |  |  |  |  |        |  |    |   |_______________________________________ S. Segment Present flag
;           |              |  |  |  |  |        |  |    |  
;           |              |  |  |  |  |        |  |    |___________________________________________ DPL. Desc. Priv. Level
;           |              |  |  |  |  |        |  |   
;           |              |  |  |  |  |        |  |________________________________________________ P. Segment Present
;           |              |  |  |  |  |        | 
;           |              |  |  |  |  |        |___________________________________________________ Segment limit start     
;           |              |  |  |  |  |____________________________________________________________ Segment limit end
;           |              |  |  |  |      
;           |              |  |  |  |_______________________________________________________________ AVL Available use by system soft      
;           |              |  |  |
;           |              |  |  |__________________________________________________________________ L 64bit code segment IA-32e mode      
;           |              |  |
;           |              |  |_____________________________________________________________________ D/B Default Operation Size      
;           |              |
;           |              |________________________________________________________________________ Granularity
;           |
;           |_______________________________________________________________________________________ Base                               
;
; IRQ, Programmable Interrupt Controller 8259A
; http://pdos.csail.mit.edu/6.828/2005/readings/hardware/8259A.pdf



bits 32
global load_gdt
global start
global load_idt
global debug_idt
global eoi_irq_a
global eoi_irq_b
extern kmain
extern kernel_start
extern kernel_end
extern isr_kernel
extern irq_kernel

%macro ISRX 1
	isr%1:
		;mov dword [0xb8000], 0x0A49 ;this is only for debug purposes
		cli
		push byte 0
		push byte %1 ; interrupt number
		jmp call_isr_kernel
%endmacro

%macro ISRX_WITHECODE 1
	isr%1:
		;mov dword [0xb8000], 0x0A48 ;this is only for debug purposes
		cli
		push byte %1
		jmp call_isr_kernel
%endmacro

%macro IRQX 1
	irq%1:
		cli
		push byte 0
		push byte %1
		jmp call_irq_kernel
%endmacro

%macro IDTX 1
	mov	eax,isr%1		;move isr address to eax
	mov	[idt+%1*8],ax		;low part of handler address
	mov word [idt+%1*8+2],0x08	;code selector
	mov word [idt+%1*8+4],0x8E00	;attributes
	shr	eax,16			;move the hight part to eax
	mov	[idt+%1*8+6],ax		;move the hight part to idt entry
%endmacro

%macro IDTX_IRQ 1
	mov	eax,irq%1		;move irq address to eax
	mov	[idt+%1*8],ax		;low part of handler address
	mov word [idt+%1*8+2],0x08	;code selector
	mov word [idt+%1*8+4],0x8E00	;attributes
	shr	eax,16			;move the hight part to eax
	mov	[idt+%1*8+6],ax		;move the hight part to idt entry
%endmacro

start:
	mov	esp,kernel_stack ;setup a new stack
	call remap_irq
	call load_gdt
	call load_idt
	call kmain

align 4
multiboot:
	MULTIBOOT_PAGE_ALIGN	equ 0x00000001
	MULTIBOOT_MEMORY_INFO	equ 0x00000002
	MULTIBOOT_AOUT_KLUDGE	equ 0x00010000
	MULTIBOOT_HEADER_MAGIC	equ 0x1BADB002
	MULTIBOOT_HEADER_FLAGS	equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
	MULTIBOOT_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_CHECKSUM

	dd multiboot
	dd kernel_start ; code, .text
	dd bss		; .data
	dd kernel_end
	dd start

;initialized vars
section .data

gdt:
	;1 first, null descriptor
	dd	0x00000000
	dd	0x00000000

	;2 code segment, CS
	dw	0xFFFF    ; Limit
	dw	0x0000    ; Base
	db	0x00      ; Base
	;	          ; P DPL S TYPE
	db	10011010b ; 1 00  1 1010  0x9A Access
	db	11001111b ; Granularity 0xC1
	db	0x00      ; base

	;3 data segment, DS
	dw	0xFFFF
	dw	0x0000
	db	0x00
	db	10010010b
	db	11001111b
	db	0x00

	;4 user code, uCS
	dw	0xFFFF
	dw	0x0000
	db	0x00
	db	10011010b
	db	00000000b
	db	0x00
	
	;5 user data, uDS
	dw	0xFFFF
	dw	0x0000
	db	0x00
	db	10010010b
	db	00000000b
	db	0x00

	;6 LDT
	dw	0x000F
	dw	0x0000
	db	0x00 ;IDT BASE
	db	10011010b
	db	11001111b
	db	0x00
gdt_end:

gdtr:
	dw	gdt_end - gdt - 1 ; size of gdt <-leng of GDT -1
	dd	gdt      ; I think base is the same size at limit but
			 ; but if i put dw here I get error. Why?
			 ; OK, limit->16 bits. Base -> 32 bits
idtr:
	dw (50*8)-1
	dd idt

;executable instructions
section .text

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
; 32-255: Maskable interrupts
; Mask 32 to 47 by irqs
IRQX 32
IRQX 33
IRQX 34
IRQX 35
IRQX 36
IRQX 37
IRQX 38
IRQX 39
IRQX 40
IRQX 41
IRQX 42
IRQX 43
IRQX 44
IRQX 45
IRQX 46
IRQX 47
;
ISRX 48
ISRX 49
ISRX 50
ISRX 51
ISRX 52
ISRX 53

call_isr_kernel:
	pusha
	mov ax, ds
	push eax
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
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

call_irq_kernel:
	pusha
	mov ax, ds
	push eax
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	call irq_kernel
	pop eax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	popa
	add esp, 8
	sti
	iret
		 
load_gdt:
	lgdt	[gdtr]
	mov ax, 0x10 ; DS location
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x08:farjump

farjump:
	ret

remap_irq:
	;remapping irq
	cli
	mov al, 0x11 ;value
	mov dx, 0x20 ;port
	out dx, al

	mov al, 0x11
	mov dx, 0xA0
	out dx, al

	;PICM to 0x20
	mov al, 0x20
	mov dx, 0x21
	out dx, al
	
	;PICS to 0x28
	mov al, 0x28
	mov dx, 0xA1
	out dx, al

	mov al, 0x04
	mov dx, 0x21
	out dx, al

	mov al, 0x02
	mov dx, 0xA1
	out dx, al

	mov al, 0x01
	mov dx, 0x21
	out dx, al

	mov al, 0x01
	mov dx, 0xA1
	out dx, al

	mov al, 0x0
	mov dx, 0x21
	out dx, al

	mov al, 0x0
	mov dx, 0XA1
	out dx, al
	sti

eoi_irq_b:
	mov al, 0x20
	mov dx, 0xA0
	out dx, al

eoi_irq_a:
	mov al, 0x20
	mov dx, 0x20
	out dx, al

load_idt:
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
	;Fom 32 to 47 are used for IRQs
	IDTX_IRQ 32
	IDTX_IRQ 33
	IDTX_IRQ 34
	IDTX_IRQ 35
	IDTX_IRQ 36
	IDTX_IRQ 37
	IDTX_IRQ 38
	IDTX_IRQ 39
	IDTX_IRQ 40
	IDTX_IRQ 41
	IDTX_IRQ 42
	IDTX_IRQ 43
	IDTX_IRQ 44
	IDTX_IRQ 45
	IDTX_IRQ 46
	IDTX_IRQ 47
	IDTX 48
	IDTX 49
	IDTX 50
	IDTX 51
	IDTX 52
	IDTX 53
	
	;load idt table
	lidt    [idtr]
	ret

;uninitialized data
section .bss
bss:
	idt:
		resd 50*2


;the stack:
resb 8400
kernel_stack:

