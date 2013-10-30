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

bits 32

; nasm syntax: http://www.nasm.us/doc/nasmdoc3.html

; multiboot specification
; http://www.gnu.org/software/grub/manual/multiboot/multiboot.html
MULTIBOOT_PAGE_ALIGN	equ 0x00000001
MULTIBOOT_MEMORY_INFO	equ 0x00000002
MULTIBOOT_AOUT_KLUDGE	equ 0x00010000
MULTIBOOT_HEADER_MAGIC	equ 0x1BADB002
MULTIBOOT_HEADER_FLAGS	equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
MULTIBOOT_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

ALIGN 4
multiboot:
	; DB Define Byte (8)
	; DW Define Word (16)
	; DD Define Double (32)
	dd MULTIBOOT_HEADER_MAGIC
	dd MULTIBOOT_HEADER_FLAGS
	dd MULTIBOOT_CHECKSUM

start:
			  ; Setup stack. Maybe better if
			  ; point it at the end of code.
	mov	sp,0x4000 ; This is stack size.
	extern	_kmain	  
	call	_kmain	  ; call kernel function
	jmp	$	  ; infinite loop
