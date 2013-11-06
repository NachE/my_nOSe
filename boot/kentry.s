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
				; Setup stack. Maybe better if
				; point it at the end of code.
	mov	esp,0x400	; This is stack size.
	jmp	0x08:load_gdt
	call	kmain		; call kernel function
	jmp	$		; infinite loop

gdt:
; using intel doc manual
; http://download.intel.com/products/processor/manual/253668.pdf
; The code sample define it as struct, Im going to try with this
;	dw	; lim_0_15  16b
;	dw	; bas_0_15  16b
;	db	; access     8b
;	db	; gran       8b
;	db	; bas_24_31  8b =

	; first, null descriptor
	dw	0
	dw	0
	db	0
	db	0
	db	0

	; code segment
	dw	0xFFFF
	dw	0xFFFF
	db	0x9A
	db	0xCF
	db	0x0

	; data
	dw	0xFFFF
	dw	0xFFFF
	db	0x92
	db	0xCF
	db	0x0


GDTLIMIT	equ ($ - gdt) ; count size of gdt:

gdtr:
	dw	GDTLIMIT ; size of gdt
	dd	gdt      ; I think base is the same size at limit but
			 ; but if i put dw here I get error. Why?
			 ; OK, limit->16 bits. Base -> 32 bits
load_gdt:
	lgdt [gdtr]
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	ret

; Maybe bss section and define kernel stack size here?
