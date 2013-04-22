#!/bin/sh
gcc -z execstack -m64 -o shellcode_test.elf shellcode_test.c
