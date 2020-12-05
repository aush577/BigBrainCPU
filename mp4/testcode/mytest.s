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
  and x5, x0, x0
  and x6, x0, x0  

  addi x2, x2, 10

  COUNTER:
    add x6, x6, 1
    add x4, x4, x6
    bne x6, x2, COUNTER

  call FUNC

  nop
  lw x4, GOOD
  
  jal x1, endloop

  FUNC:
    add x5, x5, 4
    add x6, x6, x0
    ret
    
  endloop:
    beq x0, x0, endloop
  
  lw x2, BAD
  lw x3, BAD
  lw x4, BAD

.section .rodata
.balign 256
GOOD:   .word 0x600D600D
BAD:    .word 0x00BADBAD
