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

;section .text
start:
				; Setup stack. Maybe better if
				; point it at the end of code.
	mov	esp,0x400	; This is stack size.
	call	kmain		; call kernel function
	jmp	$		; infinite loop


; Maybe bss section and define kernel stack size here?
