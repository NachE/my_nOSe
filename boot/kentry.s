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

bits 32
global load_gdt
global start
extern kmain
extern kernel_start
extern bss
extern kernel_end

; multiboot specification
; http://www.gnu.org/software/grub/manual/multiboot/multiboot.html
section .multiboot
MULTIBOOT_PAGE_ALIGN	equ 0x00000001
MULTIBOOT_MEMORY_INFO	equ 0x00000002
MULTIBOOT_AOUT_KLUDGE	equ 0x00010000
MULTIBOOT_HEADER_MAGIC	equ 0x1BADB002
MULTIBOOT_HEADER_FLAGS	equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
MULTIBOOT_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

align 4
multiboot:
	; DB Define Byte (8)
	; DW Define Word (16)
	; DD Define Double (32)
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_CHECKSUM

	dd multiboot
	dd kernel_start ; code, .text
	dd bss		; .data
	dd kernel_end
	dd start

section .text
start:
	mov	esp,kernel_stack ;stack on bss
	call	load_gdt

gdt:
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
;
; 00235612348i[CPU0 ] | SEG sltr(index|ti|rpl)     base    limit G D
; 00235612348i[CPU0 ] |  CS:0008( 0001| 0|  0) 00000000 ffffffff 1 1
;
; 00175389824i[CPU0 ] |  CS:0008( 0001| 0|  0) 00000000 1fffffff 1 1 <-- 1fffffff ???
;
	;gdtNULL:
	; first, null descriptor
	dd	0x00000000
	dd	0x00000000
	;gdtCS:
	; code segment
	dw	0xFFFF    ; Limit
	dw	0x0000    ; Base
	db	0x00      ; Base
	;	          ; P DPL S TYPE
	db	10011010b ; 1 00  1 1010  0x9A Access
	db	11001111b ; Granularity 0xC1
	db	0x00      ; base
	;gdtDS:
	; data
	dw	0xFFFF
	dw	0x0000
	db	0x00
	;db	0x92
	db	10010010b
	;db	0xC0
	db	11001111b
	db	0x00
	;gdtuCS:
	; user code
	dw	0xFFFF
	dw	0x0000
	db	0x00
	db	10011010b
	db	00000000b
	db	0x00
	;gdtuDS:
	; user data
	dw	0xFFFF
	dw	0x0000
	db	0x00
	db	10010010b
	db	00000000b
	db	0x00

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
load_gdt:
	lgdt	[gdtr]
	mov ax, 0x10 ; DS location
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp     0x08:farjump ; CS location

farjump:
	;call load_idt
	call	kmain


irqs:
%include "boot/irq.i"
section .bss
resb 0x400
kernel_stack:
