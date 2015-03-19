my_nOSe
=======

## Introduction
Small Operating System created for educational purpose

## Build Requirements
* nasm: for boot code writed on ASM
* A linker: ld on *nix or i586-elf-ld on w2k systems
* a C compiler: gcc or i586-elf-gcc
* a GNU make

You obviously can hack the source and use wherever compiler/linker you want.

## Create ISO tool requirements
There is a small and simple script on util/makeISO.sh that can build a bootable ISO. The requirements to use this script are:
* A copy of stage1 and stage2 of grub x86. This will be copied from /boot dir, but you can edit the script and change that (really, the script is so simple and small)
* a grub-mkrescue or grub2-mkrescue command

The use of grub is a strong dependence because the boot is based on it.


## Run OS Requirements
At the same time you build a ISO file with the tool described abobe, you can burn it and use on a real hardware (i386 compatible). Moreover, you can use an emulator like qemu or bochs. Inside util/ directory you can found 'startbochs.sh' and 'startqemu.sh' with a command-line used to start the .iso file. Also, qemu have the hability to start the kernel in raw mode, so you can start it whitout generate ISO file (with some funny bugs :D).

The recomended emulator for debug and dev is bochs because it have heavily debug options.
