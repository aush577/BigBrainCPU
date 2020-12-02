# mytest.s:
.align 4
.section .text
.globl _start
  # Refer to the RISC-V ISA Spec for the functionality of
  # the instructions in this test program.
_start:

  # and x1, x0, x0
  # and x2, x0, x0
  # and x4, x0, x0

  # addi x2, x2, 10

  # COUNTER:
  #   add x1, x1, 1
  #   # lw x5, GOOD
  #   add x4, x4, x1
  #   bne x1, x2, COUNTER

  # lw x4, GOOD
  # jal x7, endloop

  temp:
    la x1, done
    jalr x7, x1
    lw x2, BAD
    lw x3, BAD
    lw x4, BAD
    beq x0, x0, endloop

  done:
   lw x2, GOOD
   jalr x7

  endloop:
    beq x0, x0, endloop
    # jal x7, endloop

.section .rodata
.balign 256
GOOD:   .word 0x600D600D
BAD:    .word 0x00BADBAD
