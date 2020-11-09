# mytest.s:
.align 4
.section .text
.globl _start
  # Refer to the RISC-V ISA Spec for the functionality of
  # the instructions in this test program.
_start:
   
  lw x8, deadbeef     # x8 <= M[deadbeef]
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  
  # la x10, store       # x10 <= ADDR[store]
  # nop
  # nop
  # nop
  # nop
  # nop
  # nop
  # nop
  
  # sw x8, 0(x10)       # M[x10] <= x8
  # nop
  # nop
  # nop
  # nop
  # nop
  # nop
  # nop

  # lw x9, store        # x9 <= M[store]
  # nop
  # nop
  # nop
  # nop
  # nop
  # nop
  # nop

  # la x10, deadbeef
  # lb x8, 2(x10)
  # lhu x8, 1(x10)

  # lw x8, deadbeef
  # la x10, store
  # sh x8, 2(x10)
  # lw x9, store

  # jalr x8, x0, 124

  # addi x8, x0, -8
  # addi x9, x0, 1
  # add x10, x8, x9
  # sub x10, x8, x9
  # xor x10, x8, x9
  # sra x10, x8, x9

endloop:
  beq x0, x0, endloop
  nop
  nop
  nop
  nop
  nop
  nop
  nop

.section .rodata
.balign 256
deadbeef: .word 0xdeadbeef
store:    .word 0xabcdabcd