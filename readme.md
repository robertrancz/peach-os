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

## [Creating a cross compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
- Install the following packages:
![Dependencies](readme-files/deps.jpg)
- [Download GNU bin utils](https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.xz)
- [Download GCC](https://ftp.igh.cnrs.fr/pub/gnu/gcc/gcc-10.2.0/)
- Unzip the archives to your `home/src` folder and follow the instructions on the page to build and install binutils and gcc.
Note that it might needed to make `./configure`, `./move-if-change` and `mkheader.sh` in gcc source code executable for the build to succeed using `chmod +x`.
- If everything is going well, at the end the cross compiler should be available in your `~/opt/cross` directory:
![Dependencies](readme-files/deps.jpg)
