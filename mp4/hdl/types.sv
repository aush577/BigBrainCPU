package types;

import rv32i_types::*;

// For decoded instruction
typedef struct packed {
  logic [2:0] funct3;
  logic [6:0] funct7;
  rv32i_opcode opcode;
  logic [31:0] i_imm;
  logic [31:0] s_imm;
  logic [31:0] b_imm;
  logic [31:0] u_imm;
  logic [31:0] j_imm;
  logic [4:0] rs1;
  logic [4:0] rs2;
  logic [4:0] rd;
} instr_struct;

// Pipe control signals
typedef struct packed {
  logic ifid_ireg_ld;
  logic ifid_pcreg_ld;

  logic idex_ireg_ld;
  logic idex_pcreg_ld;
  logic idex_rs1reg_ld;
  logic idex_rs2reg_ld;
  logic idex_ctrlreg_ld;

  logic exmem_ireg_ld;
  logic exmem_pcreg_ld;
  logic exmem_rs2reg_ld;
  logic exmem_ctrlreg_ld;
  logic exmem_alureg_ld;
  logic exmem_brreg_ld;

  logic memwb_ireg_ld;
  logic memwb_pcreg_ld;
  logic memwb_ctrlreg_ld;
  logic memwb_alureg_ld;
  logic memwb_brreg_ld;
  logic memwb_memdatareg_ld;
} pipe_ctrl_struct;

// Control word signals
typedef struct packed {
  logic pcreg_ld;
  logic pcmux_sel;
  logic regfile_ld;
  alumux::alumux1_sel_t alumux1_sel;
  alumux::alumux2_sel_t alumux2_sel;
  cmpmux::cmpmux_sel_t cmpmux_sel;
  regfilemux::regfilemux_sel_t regfilemux_sel;
} ctrl_word_struct;

endpackage : types
