#!/bin/bash
bochs 'ata1-master: type=cdrom, path="./nOSe_test.iso", status=inserted' 'boot: cdrom' 'romimage: file=/usr/share/bochs/BIOS-bochs-latest' 'display_library: sdl'
