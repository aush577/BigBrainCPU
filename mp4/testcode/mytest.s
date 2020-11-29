# mytest.s:
.align 4
.section .text
.globl _start
  # Refer to the RISC-V ISA Spec for the functionality of
  # the instructions in this test program.
_start:

  and x1, x0, x0
  and x2, x0, x0
  and x4, x0, x0

  addi x2, x2, 10

  COUNTER:
    add x1, x1, 1
    lw x4, GOOD
    bne x1, x2, COUNTER

  endloop:
    beq x0, x0, endloop

.section .rodata
.balign 256
GOOD:   .word 0x600D600D