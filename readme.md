# Peach OS
## Overview
- Multithreaded kernel

## Enable protected mode
- Check protected mode enabled:

`gdb`

`target remote | qemu-system-x86_64 -hda ./boot.bin -S -gdb stdio`

`Ctrl+C`

`layout asm`

`info registers`

![Protected mode enabled](readme-files/protected-mode.jpg)

- After enabling protected mode, the kernel is running in 32bit mode, we can no longer access the BIOS. We need to write a disk driver if we want to read from the disk.