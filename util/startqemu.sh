#!/bin/bash
qemu -cdrom nOSe_test.iso -monitor stdio -m 32 || qemu-system-i386 -cdrom nOSe_test.iso -monitor stdio -m 32 
