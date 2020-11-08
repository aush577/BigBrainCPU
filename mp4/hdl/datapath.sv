`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;
import types::*;

module datapath (
  input clk,
  input rst,

  // I-Cache
  input icache_resp,
  input icache_rdata,
  output icache_address,
  output icache_read,
  output icache_write,
  output icache_wdata,
  output icache_mbe,

  // D-Cache
  input dcache_resp,
  input dcache_rdata,
  output dcache_address,
  output dcache_read,
  output dcache_write,
  output dcache_wdata,
  output dcache_mbe

);

// ******************** Internal Signals ********************
instr_struct ifid_ireg_out;
instr_struct idex_ireg_out;
instr_struct exmem_ireg_out;
instr_struct memwb_ireg_out;

pipe_ctrl_struct pipe_ctrl;

ctrl_word_struct ctrl_word_out;
ctrl_word_struct idex_ctrlreg_out;
ctrl_word_struct exmem_ctrlreg_out;
ctrl_word_struct memwb_ctrlreg_out;

logic [31:0] pcreg_out;
logic [31:0] pcmux_out;
pcmux::pcmux_sel_t pcmux_sel;

logic [31:0] regfilemux_out;
logic [31:0] regfile_rs1_out;
logic [31:0] regfile_rs2_out;
logic [31:0] idex_rs1reg_out;
logic [31:0] idex_rs2reg_out;
logic [31:0] exmem_rs1reg_out;
logic [31:0] exmem_rs2reg_out;
logic [31:0] exmem_alureg_out;
logic exmem_brreg_out;

logic [31:0] alumux1_out;
logic [31:0] alumux2_out;

logic [31:0] cmpmux_out;
logic br_en_cmp;
logic br_en;

logic br_signal;
logic jal_signal;
logic jalr_signal;

// Function to decode instruction into useful pieces
function instr_decode (logic [31:0] data);
  // instr_struct coming from types.sv
  instr_struct instr;

  instr.funct3 = data[14:12];
  instr.funct7 = data[31:25];
  instr.opcode = rv32i_opcode'(data[6:0]);
  instr.i_imm = {{21{data[31]}}, data[30:20]};
  instr.s_imm = {{21{data[31]}}, data[30:25], data[11:7]};
  instr.b_imm = {{20{data[31]}}, data[7], data[30:25], data[11:8], 1'b0};
  instr.u_imm = {data[31:12], 12'h000};
  instr.j_imm = {{12{data[31]}}, data[19:12], data[20], data[30:21], 1'b0};
  instr.rs1 = data[19:15];
  instr.rs2 = data[24:20];
  instr.rd = data[11:7];
  return instr;

endfunction


// ******************** IF Stage ********************

always_comb begin : IF_MUXES
  unique case (pcmux_sel)
    pcmux::pc_plus4:  pcmux_out = pcreg_out + 4;
    pcmux::alu_out:   pcmux_out = exmem_alureg_out;
    default: `BAD_MUX_SEL;
  endcase
end

assign pcmux_sel = pcmux::pcmux_sel_t'(exmem_brreg_out);
assign icache_address = pcreg_out;

pc_register pcreg (
  .*,
  .load(1'b1),
  .in(pcmux_out),
  .out(pcreg_out)
);

// ******************** ID Stage ********************
regfile rf (
  .*, 
  .load(memwb_ctrlreg_out.regfile_ld), 
  .in(regfilemux_out),
  .src_a(ifid_ireg_out.rs1),
  .src_b(ifid_ireg_out.rs2), 
  .dest(memwb_ireg_out.rd), 
  .reg_a(regfile_rs1_out),
  .reg_b(regfile_rs2_out)
);

ctrl_rom ctrl_rom(
  .opcode(ifid_ireg_out.opcode),
  .funct3(ifid_ireg_out.funct3),
  .funct7(ifid_ireg_out.funct7),
  .ctrl_word(ctrl_word_out)
);

// ******************** EX Stage ********************

always_comb begin : EX_MUXES
  unique case (idex_ctrlreg_out.alumux1_sel)
    alumux::rs1_out:	alumux1_out = idex_rs1reg_out;
    alumux::pc_out:	  alumux1_out = idex_pcreg_out;
    default: `BAD_MUX_SEL;
  endcase

  unique case (idex_ctrlreg_out.alumux2_sel)
    alumux::i_imm:		alumux2_out = idex_ireg_out.i_imm;
    alumux::u_imm:		alumux2_out = idex_ireg_out.u_imm;
    alumux::b_imm:		alumux2_out = idex_ireg_out.b_imm;
    alumux::s_imm:		alumux2_out = idex_ireg_out.s_imm;
    alumux::j_imm:		alumux2_out = idex_ireg_out.j_imm;
    alumux::rs2_out:	alumux2_out = idex_rs2reg_out;
    default: `BAD_MUX_SEL;
  endcase

  unique case (idex_ctrlreg_out.cmpmux_sel)
    cmpmux::rs2_out:	cmpmux_out = idex_rs2reg_out;
    cmpmux::i_imm: 	  cmpmux_out = idex_ireg_out.i_imm;
    default: `BAD_MUX_SEL;
  endcase
end

cmp cmp(
  .cmpop(branch_funct3_t'(idex_ireg_out.funct3)),
  .rs1_out(idex_rs1reg_out),
	.i_imm(idex_ireg_out.i_imm),
	.br_en(br_en_cmp)
);

alu alu(
  .*, 
  .a(alumux1_out), 
  .b(alumux2_out), 
  .aluop(alu_ops'(idex_ireg_out.funct3)),  // Casting 3 bits to arith type
  .f(alu_out)
);

always_comb begin: JUMP_LOGIC
  br_signal = ((idex_ireg_out.opcode == op_br) && br_en_cmp) ? 1'b1 : 1'b0;
  jal_signal = (idex_ireg_out.opcode == op_jal) ? 1'b1 : 1'b0;
  jalr_signal = (idex_ireg_out.opcode == op_jalr) ? 1'b1 : 1'b0;

  br_en = br_signal | jal_signal | jalr_signal;
end

// ******************** MEM Stage ********************


// ******************** WB Stage ********************

always_comb begin : WB_MUXES
  unique case (memwb_ctrlreg_out.regfilemux_sel)
    regfilemux::alu_out: regfilemux_out = memwb_alureg_out;
    regfilemux::u_imm: regfilemux_out = memwb_ireg_out.u_imm;
    regfilemux::pc_plus4: regfilemux_out = memwb_pcreg_out + 4;
    regfilemux::br_en: regfilemux_out =  memwb_brreg_out;
    regfilemux::lw: regfilemux_out = 32'b0;    //TODO
    regfilemux::lh: regfilemux_out = 32'b0;    //TODO
    regfilemux::lb: regfilemux_out = 32'b0;    //TODO
    regfilemux::lbu: regfilemux_out = 32'b0;  //TODO
    regfilemux::lhu: regfilemux_out  = 32'b0; //TODO
    default: `BAD_MUX_SEL;
  endcase
end

// ******************** IF/ID Pipeline Registers ********************
// $bits returns size of struct in bits
register #(.width($bits(instr_struct)))
ifid_ireg (
  .*,
  .load(pipe_ctrl.ifid_ireg_ld),
  .in(instr_decode(icache_rdata)),
  .out(ifid_ireg_out)
);

register #(.width(32))
ifid_pcreg (
  .*,
  .load(pipe_ctrl.ifid_pcreg_ld),
  .in(pcreg_out),
  .out(ifid_pcreg_out)
);

// ******************** ID/EX Pipeline Registers ********************
register #(.width($bits(instr_struct)))
idex_ireg (
  .*,
  .load(pipe_ctrl.idex_ireg_ld),
  .in(ifid_ireg_out),
  .out(idex_ireg_out)
);

register #(.width(32))
idex_pcreg (
  .*,
  .load(pipe_ctrl.idex_pcreg_ld),
  .in(ifid_pcreg_out),
  .out(idex_pcreg_out)
);

register #(.width(32))
idex_rs1reg (
  .*,
  .load(pipe_ctrl.idex_rs1reg_ld),
  .in(regfile_rs1_out),
  .out(idex_rs1reg_out)
);

register #(.width(32))
idex_rs2reg (
  .*,
  .load(pipe_ctrl.idex_rs2reg_ld),
  .in(regfile_rs2_out),
  .out(idex_rs2reg_out)
);

register #(.width(32))
idex_ctrlreg (
  .*,
  .load(pipe_ctrl.idex_ctrlreg_ld),
  .in(ctrl_word_out),
  .out(idex_ctrlreg_out)
);

// ******************** EX/MEM Pipeline Registers ********************
register #(.width($bits(instr_struct)))
exmem_ireg (
  .*,
  .load(pipe_ctrl.exmem_ireg_ld),
  .in(idex_ireg_out),
  .out(exmem_ireg_out)
);

register #(.width(32))
exmem_pcreg (
  .*,
  .load(pipe_ctrl.exmem_pcreg_ld),
  .in(idex_pcreg_out),
  .out(exmem_pcreg_out)
);

register #(.width(32))
exmem_rs2reg (
  .*,
  .load(pipe_ctrl.exmem_rs2reg_ld),
  .in(idex_rs2reg_out),
  .out(exmem_rs2reg_out)
);

register #(.width(32))
exmem_ctrlreg (
  .*,
  .load(pipe_ctrl.exmem_ctrlreg_ld),
  .in(idex_ctrlreg_out),
  .out(exmem_ctrlreg_out)
);

register #(.width(32))
exmem_alureg (
  .*,
  .load(pipe_ctrl.exmem_alureg_ld),
  .in(alu_out),
  .out(exmem_alureg_out)
);

register #(.width(1))
exmem_brreg (
  .*,
  .load(pipe_ctrl.exmem_brreg_ld),
  .in(br_en),
  .out(exmem_brreg_out)
);


// ******************** MEM/WB Pipeline Registers ********************
register #(.width($bits(instr_struct)))
memwb_ireg (
  .*,
  .load(pipe_ctrl.memwb_ireg_ld),
  .in(exmem_ireg_out),
  .out(memwb_ireg_out)
);

register #(.width(32))
memwb_pcreg (
  .*,
  .load(pipe_ctrl.memwb_pcreg_ld),
  .in(exmem_pcreg_out),
  .out(memwb_pcreg_out)
);

register #(.width(32))
memwb_ctrlreg (
  .*,
  .load(pipe_ctrl.memwb_ctrlreg_ld),
  .in(exmem_ctrlreg_out),
  .out(memwb_ctrlreg_out)
);

register #(.width(32))
memwb_alureg (
  .*,
  .load(pipe_ctrl.memwb_alureg_ld),
  .in(exmem_alureg_out),
  .out(memwb_alureg_out)
);

register #(.width(1))
memwb_brreg (
  .*,
  .load(pipe_ctrl.memwb_brreg_ld),
  .in(exmem_brreg_out),
  .out(memwb_brreg_out)
);

register #(.width(32))
memwb_memrdata (
  .*,
  .load(pipe_ctrl.memwb_memdatareg_ld),
  .in(dcache_rdata),
  .out(memwb_memdatareg_out)
);

endmodule : datapath
