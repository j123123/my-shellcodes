#!/bin/sh
cpp -x assembler-with-cpp shellcode_linux_x86-64.S | as - -march=generic64 -mtune=generic64 -o shellcode_linux_x86-64.o
ld -T ldscript  --oformat binary --strip-all shellcode_linux_x86-64.o -o shellcode_linux_x86-64.bin
rm shellcode_linux_x86-64.o
