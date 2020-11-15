`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;
import types::*;

module datapath (
  input clk,
  input rst,

  // I-Cache
  input logic icache_resp,
  input logic [31:0] icache_rdata,
  output logic [31:0] icache_address,
  output logic icache_read,

  // D-Cache
  input logic dcache_resp,
  input logic [31:0] dcache_rdata,
  output logic [31:0] dcache_address,
  output logic dcache_read,
  output logic dcache_write,
  output logic [31:0] dcache_wdata,
  output logic [3:0] dcache_mbe
);

// ******************** Internal Signals BEGIN ********************
// IF
logic [31:0] pcreg_out;
logic [31:0] pcmux_out;
pcmux::pcmux_sel_t pcmux_sel;

// IF/ID
instr_struct ifid_ireg_out;
logic [31:0] ifid_pcreg_out;

// ID
ctrl_word_struct ctrl_word_out;
logic [31:0] regfile_rs1_out;
logic [31:0] regfile_rs2_out;

// ID/EX
instr_struct idex_ireg_out;
logic [31:0] idex_pcreg_out;
ctrl_word_struct idex_ctrlreg_out;
logic [31:0] idex_rs1reg_out;
logic [31:0] idex_rs2reg_out;

// EX
logic [31:0] alumux1_out;
logic [31:0] alumux2_out;
logic [31:0] alu_out;
logic [31:0] cmpmux_out;
logic br_en_cmp;
logic br_en;
logic br_signal;
logic jal_signal;
logic jalr_signal;

// EX/MEM
instr_struct exmem_ireg_out;
logic [31:0] exmem_pcreg_out;
ctrl_word_struct exmem_ctrlreg_out;
logic [31:0] exmem_rs2reg_out;
logic [31:0] exmem_alureg_out;
logic exmem_brreg_out;

// MEM

// MEM/WB
instr_struct memwb_ireg_out;
logic [31:0] memwb_pcreg_out;
ctrl_word_struct memwb_ctrlreg_out;
logic [31:0] memwb_alureg_out;
logic memwb_brreg_out;
logic [31:0] memwb_memdatareg_out;

// WB
logic [31:0] regfilemux_out;
logic [31:0] lb_out;
logic [31:0] lbu_out;
logic [31:0] lh_out;
logic [31:0] lhu_out;
logic [31:0] lw_out;

// Other
pipe_ctrl_struct pipe_ctrl;
assign pipe_ctrl = {$bits(pipe_ctrl_struct){1'b1}};

// ******************** Internal Signals END ********************


// ******************** Functions BEGIN********************

// Function to decode instruction into useful pieces
function instr_struct instr_decode (logic [31:0] data);
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

// ******************** Functions END ********************



// ******************** Stages BEGIN ********************

//  ********** IF Stage **********
always_comb begin : IF_MUXES
  unique case (pcmux_sel)
    pcmux::pc_plus4:  pcmux_out = pcreg_out + 4;
    pcmux::alu_out:   pcmux_out = {exmem_alureg_out[31:2], 2'b0};
    default: `BAD_MUX_SEL;
  endcase
end

assign pcmux_sel = pcmux::pcmux_sel_t'(exmem_brreg_out);
assign icache_address = {pcreg_out[31:2], 2'b0};
assign icache_read = (rst) ? 1'b0 : 1'b1;

pc_register pcreg (
  .*,
  .load(1'b1),
  .in(pcmux_out),
  .out(pcreg_out)
);


// ********** ID Stage **********
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


// ********** EX Stage **********
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
  .cmpop(idex_ctrlreg_out.cmpop),
  .rs1_out(idex_rs1reg_out),
	.cmpmux_out(cmpmux_out),
	.br_en(br_en_cmp)
);

alu alu(
  .a(alumux1_out), 
  .b(alumux2_out), 
  .aluop(idex_ctrlreg_out.aluop),
  .f(alu_out)
);

always_comb begin: JUMP_LOGIC
  br_signal = ((idex_ireg_out.opcode == op_br) && br_en_cmp) ? 1'b1 : 1'b0;
  jal_signal = (idex_ireg_out.opcode == op_jal) ? 1'b1 : 1'b0;
  jalr_signal = (idex_ireg_out.opcode == op_jalr) ? 1'b1 : 1'b0;

  br_en = br_signal | jal_signal | jalr_signal;
end


// ********** MEM Stage **********
assign dcache_address = {exmem_alureg_out[31:2], 2'b0};
assign dcache_read = exmem_ctrlreg_out.dcache_read;
assign dcache_write = exmem_ctrlreg_out.dcache_write;

always_comb begin: WDATA_LOGIC // Store instructions
// Get exmem_alureg_out and exmem_rs2reg_out
// Use these to then decide on what to store
// Based on store word, we decide on how much we shift rs2
  logic [4:0] bit_shift;
  logic [1:0] byte_shift;
  store_funct3_t store_funct;
  bit_shift = exmem_alureg_out[1:0] << 3;
  byte_shift = exmem_alureg_out[1:0];
  store_funct = store_funct3_t'(exmem_ireg_out.funct3);
  
  if (store_funct == sb) begin      // sb
    dcache_wdata = exmem_rs2reg_out << bit_shift;
    dcache_mbe = 4'b0001 << byte_shift;
  end
  else if (store_funct == sh) begin // sh
    dcache_wdata = exmem_rs2reg_out << bit_shift;
    dcache_mbe = 4'b0011 << byte_shift;
  end
  else if (store_funct == sw) begin // sw
    dcache_wdata = exmem_rs2reg_out;
    dcache_mbe = 4'b1111;
  end
  else begin
    dcache_wdata = 32'b0;
    dcache_mbe = 4'b0000;
  end

end


// ********** WB Stage **********
always_comb begin : WB_MUXES
  unique case (memwb_ctrlreg_out.regfilemux_sel)
    regfilemux::alu_out: regfilemux_out = memwb_alureg_out;
    regfilemux::u_imm: regfilemux_out = memwb_ireg_out.u_imm;
    regfilemux::pc_plus4: regfilemux_out = memwb_pcreg_out + 4;
    regfilemux::br_en: regfilemux_out = {31'd0, memwb_brreg_out};
    regfilemux::lw: regfilemux_out = lw_out;  // memwb_memdatareg_out
    regfilemux::lh: regfilemux_out = lh_out;
    regfilemux::lb: regfilemux_out = lb_out;
    regfilemux::lbu: regfilemux_out = lbu_out;
    regfilemux::lhu: regfilemux_out  = lhu_out;
    default: `BAD_MUX_SEL;
  endcase
end

always_comb begin : LOAD_LOGIC // Load instructions
  lw_out = memwb_memdatareg_out;

  unique case (memwb_alureg_out[1:0])
    2'b00: lh_out = {{16{memwb_memdatareg_out[15]}}, memwb_memdatareg_out[15:0]};
    2'b10: lh_out = {{16{memwb_memdatareg_out[31]}}, memwb_memdatareg_out[31:16]};
    default: lh_out = 32'b0;
  endcase

  unique case (memwb_alureg_out[1:0])
    2'b00: lb_out = {{24{memwb_memdatareg_out[ 7]}}, memwb_memdatareg_out[7:0]};
    2'b01: lb_out = {{24{memwb_memdatareg_out[15]}}, memwb_memdatareg_out[15:8]};
    2'b10: lb_out = {{24{memwb_memdatareg_out[23]}}, memwb_memdatareg_out[23:16]};
    2'b11: lb_out = {{24{memwb_memdatareg_out[31]}}, memwb_memdatareg_out[31:24]};
    default: lb_out = 32'b0;
  endcase

  unique case (memwb_alureg_out[1:0])
    2'b00: lbu_out = {24'b0, memwb_memdatareg_out[7:0]};
    2'b01: lbu_out = {24'b0, memwb_memdatareg_out[15:8]};
    2'b10: lbu_out = {24'b0, memwb_memdatareg_out[23:16]};
    2'b11: lbu_out = {24'b0, memwb_memdatareg_out[31:24]};
    default: lbu_out = 32'b0;
  endcase

  unique case (memwb_alureg_out[1:0])
    2'b00: lhu_out = {16'b0, memwb_memdatareg_out[15:0]};
    2'b10: lhu_out = {16'b0, memwb_memdatareg_out[31:16]};
    default: lhu_out = 32'b0;
  endcase
end

// ******************** Stages END ********************





// ******************** Pipeline Registers BEGIN ********************
// ********** IF/ID Pipeline Registers **********
// $bits returns size of struct in bits
register #(.width($bits(instr_struct)))
ifid_ireg (
  .*,
  .load(pipe_ctrl.ifid_ld),
  .in(instr_decode(icache_rdata)),
  .out(ifid_ireg_out)
);

register #(.width(32))
ifid_pcreg (
  .*,
  .load(pipe_ctrl.ifid_ld),
  .in(pcreg_out),
  .out(ifid_pcreg_out)
);


// ********** ID/EX Pipeline Registers **********
register #(.width($bits(instr_struct)))
idex_ireg (
  .*,
  .load(pipe_ctrl.idex_ld),
  .in(ifid_ireg_out),
  .out(idex_ireg_out)
);

register #(.width(32))
idex_pcreg (
  .*,
  .load(pipe_ctrl.idex_ld),
  .in(ifid_pcreg_out),
  .out(idex_pcreg_out)
);

register #(.width(32))
idex_rs1reg (
  .*,
  .load(pipe_ctrl.idex_ld),
  .in(regfile_rs1_out),
  .out(idex_rs1reg_out)
);

register #(.width(32))
idex_rs2reg (
  .*,
  .load(pipe_ctrl.idex_ld),
  .in(regfile_rs2_out),
  .out(idex_rs2reg_out)
);

register #(.width($bits(ctrl_word_struct)))
idex_ctrlreg (
  .*,
  .load(pipe_ctrl.idex_ld),
  .in(ctrl_word_out),
  .out(idex_ctrlreg_out)
);


// ********** EX/MEM Pipeline Registers **********
register #(.width($bits(instr_struct)))
exmem_ireg (
  .*,
  .load(pipe_ctrl.exmem_ld),
  .in(idex_ireg_out),
  .out(exmem_ireg_out)
);

register #(.width(32))
exmem_pcreg (
  .*,
  .load(pipe_ctrl.exmem_ld),
  .in(idex_pcreg_out),
  .out(exmem_pcreg_out)
);

register #(.width(32))
exmem_rs2reg (
  .*,
  .load(pipe_ctrl.exmem_ld),
  .in(idex_rs2reg_out),
  .out(exmem_rs2reg_out)
);

register #(.width($bits(ctrl_word_struct)))
exmem_ctrlreg (
  .*,
  .load(pipe_ctrl.exmem_ld),
  .in(idex_ctrlreg_out),
  .out(exmem_ctrlreg_out)
);

register #(.width(32))
exmem_alureg (
  .*,
  .load(pipe_ctrl.exmem_ld),
  .in(alu_out),
  .out(exmem_alureg_out)
);

register #(.width(1))
exmem_brreg (
  .*,
  .load(pipe_ctrl.exmem_ld),
  .in(br_en),
  .out(exmem_brreg_out)
);


// ********** MEM/WB Pipeline Registers **********
register #(.width($bits(instr_struct)))
memwb_ireg (
  .*,
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_ireg_out),
  .out(memwb_ireg_out)
);

register #(.width(32))
memwb_pcreg (
  .*,
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_pcreg_out),
  .out(memwb_pcreg_out)
);

register #(.width($bits(ctrl_word_struct)))
memwb_ctrlreg (
  .*,
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_ctrlreg_out),
  .out(memwb_ctrlreg_out)
);

register #(.width(32))
memwb_alureg (
  .*,
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_alureg_out),
  .out(memwb_alureg_out)
);

register #(.width(1))
memwb_brreg (
  .*,
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_brreg_out),
  .out(memwb_brreg_out)
);

register #(.width(32))
memwb_memrdata (
  .*,
  .load(pipe_ctrl.memwb_ld),
  .in(dcache_rdata),
  .out(memwb_memdatareg_out)
);

// ******************** Pipeline Registers END ********************


endmodule : datapath