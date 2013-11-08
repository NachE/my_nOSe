#!/bin/bash
bochs 'ata1-master: type=cdrom, path="./nOSe_test.iso", status=inserted' 'boot: cdrom' 'romimage: file=/usr/share/bochs/BIOS-bochs-latest, address=0xe0000' 'display_library: sdl'
