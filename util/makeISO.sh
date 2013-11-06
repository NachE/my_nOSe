#!/bin/bash
# Documentation at: 
# http://www.gnu.org/software/grub/manual/html_node/Making-a-GRUB-bootable-CD_002dROM.html
# http://www.gnu.org/software/grub/manual/html_node/Simple-configuration.html#Simple-configuration
# http://www.gnu.org/software/grub/manual/html_node/Multi_002dboot-manual-config.html

mkdir -p iso/boot/grub 2>/dev/null
cp -rf knOSe iso/boot/
cp /boot/grub/stage1 /boot/grub/stage2 iso/boot/grub/
cp /boot/x86_boot/grub/stage1 /boot/x86_boot/grub/stage2 iso/boot/grub/
echo -e "set timeout=3\nset default=0\nmenuentry 'nOSe ALPHA'{\nmultiboot /boot/knOSe\nboot\n}" >iso/boot/grub/grub.cfg
echo "Create iso"
grub-mkrescue -o nOSe_test.iso iso || grub2-mkrescue -o nOSe_test.iso iso
# xorriso on opensuse is on libburnia-tools

