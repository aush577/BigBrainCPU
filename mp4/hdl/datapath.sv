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
logic [31:0] pc_input;

logic [31:0] cp3_address;
assign cp3_address = icache_address - 32'h60 + 32'h100;

// IF/ID
instr_struct ifid_ireg_out;
logic [31:0] ifid_pcreg_out;
logic ifid_btb_take_out;

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
logic idex_btb_take_out;

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

forwardmux1::forwardmux1_sel_t forwardmux1_sel;
forwardmux2::forwardmux2_sel_t forwardmux2_sel;
logic [31:0] forwardmux1_out;
logic [31:0] forwardmux2_out;

// EX/MEM
instr_struct exmem_ireg_out;
logic [31:0] exmem_pcreg_out;
ctrl_word_struct exmem_ctrlreg_out;
logic [31:0] exmem_rs2reg_out;
logic [31:0] exmem_alureg_out;
logic exmem_brreg_out;

// MEM
mem_forwardmux2::mem_forwardmux2_sel_t mem_forwardmux2_sel;
logic [31:0] mem_forwardmux2_out;
logic [31:0] lb_out;
logic [31:0] lbu_out;
logic [31:0] lh_out;
logic [31:0] lhu_out;
logic [31:0] lw_out;
logic [31:0] load_logic_out;
logic [3:0] load_dcache_mbe;  // Not connected to anything, needed for rvfi

// MEM/WB
instr_struct memwb_ireg_out;
logic [31:0] memwb_pcreg_out;
ctrl_word_struct memwb_ctrlreg_out;
logic [31:0] memwb_alureg_out;
logic memwb_brreg_out;
logic [31:0] memwb_memdatareg_out;

// WB
logic [31:0] regfilemux_out;

// Branch prediction
logic btb_hit;
logic [31:0] btb_pc_out;
logic pred_br;

// dCache stall
logic dcache_stall;
assign dcache_stall = (dcache_read | dcache_write) & ~dcache_resp;

// iCache stall
logic icache_stall;
assign icache_stall = icache_read & ~icache_resp;

// Branch misprediction flush
logic flush_sig;
// assign flush_sig = (br_en == 1'b1) & ~dcache_stall & ~icache_stall; //Static not taken
assign flush_sig = (br_en != idex_btb_take_out) & ~dcache_stall & ~icache_stall;

// Pipe control signals
pipe_ctrl_struct pipe_ctrl;
assign pipe_ctrl.ifid_ld = ~dcache_stall & ~icache_stall;
assign pipe_ctrl.idex_ld = ~dcache_stall & ~icache_stall;
assign pipe_ctrl.exmem_ld = ~dcache_stall & ~icache_stall;
assign pipe_ctrl.memwb_ld = ~dcache_stall & ~icache_stall;
assign pipe_ctrl.ifid_rst = rst | flush_sig;
assign pipe_ctrl.idex_rst = rst | flush_sig;
assign pipe_ctrl.exmem_rst = rst;
assign pipe_ctrl.memwb_rst = rst;


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
  // unique case (pcmux_sel)
  //   pcmux::pc_plus4:  pcmux_out = pcreg_out + 4;
  //   pcmux::alu_out:   pcmux_out = {alu_out[31:2], 2'b0};
  //   // pcmux::alu_out:   pcmux_out = btb_hit ? btb_pc_out : {alu_out[31:2], 2'b0};
  //   default: `BAD_MUX_SEL;
  // endcase

  unique case ({br_en, idex_btb_take_out})
    2'b00: begin
      pcmux_out = pcreg_out + 4;
    end
    2'b01: begin
      pcmux_out = idex_pcreg_out + 4;
    end
    2'b10: begin
      pcmux_out = {alu_out[31:2], 2'b0};
    end
    2'b11: begin
      pcmux_out = pcreg_out + 4;
    end
    default : begin
      pcmux_out = pcreg_out + 4;
    end
  endcase

  if (pred_br & btb_hit & (br_en == idex_btb_take_out)) begin
    pc_input = btb_pc_out;
  end else begin
    pc_input = pcmux_out;
  end
end

assign pcmux_sel = pcmux::pcmux_sel_t'(br_en);
assign icache_address = {pcreg_out[31:2], 2'b0};
assign icache_read = (rst) ? 1'b0 : 1'b1;

pc_register pcreg (
  .*,
  .load(~dcache_stall & ~icache_stall),
  // .in(pcmux_out),
  .in(pc_input),
  .out(pcreg_out)
);


// ********** ID Stage **********
regfile rf (
  .*, 
  .load(memwb_ctrlreg_out.regfile_ld), // && ~dcache_stall & ~icache_stall),
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
  unique case (forwardmux1_sel)
    forwardmux1::idex_rs1:  forwardmux1_out = idex_rs1reg_out;
    forwardmux1::exmem_alu: forwardmux1_out = exmem_alureg_out;
    forwardmux1::regfilemux:   forwardmux1_out = regfilemux_out;
    forwardmux1::mem_rdata: forwardmux1_out = load_logic_out;
    forwardmux1::mem_uimm: forwardmux1_out = exmem_ireg_out.u_imm;
    forwardmux1::cmp_br: forwardmux1_out = exmem_brreg_out;
    default: forwardmux1_out = idex_rs1reg_out;
  endcase

  unique case (forwardmux2_sel)
    forwardmux2::idex_rs2:  forwardmux2_out = idex_rs2reg_out;
    forwardmux2::exmem_alu: forwardmux2_out = exmem_alureg_out;
    forwardmux2::regfilemux:   forwardmux2_out = regfilemux_out;
    forwardmux2::mem_rdata: forwardmux2_out = load_logic_out;
    forwardmux2::mem_uimm: forwardmux2_out = exmem_ireg_out.u_imm;
    forwardmux2::cmp_br: forwardmux2_out = exmem_brreg_out;
    default: forwardmux2_out = idex_rs2reg_out;
  endcase

  unique case (idex_ctrlreg_out.alumux1_sel)
    // alumux::rs1_out:	alumux1_out = idex_rs1reg_out;
    alumux::rs1_out:	alumux1_out = forwardmux1_out;
    alumux::pc_out:	  alumux1_out = idex_pcreg_out;
    default: `BAD_MUX_SEL;
  endcase

  unique case (idex_ctrlreg_out.alumux2_sel)
    alumux::i_imm:		alumux2_out = idex_ireg_out.i_imm;
    alumux::u_imm:		alumux2_out = idex_ireg_out.u_imm;
    alumux::b_imm:		alumux2_out = idex_ireg_out.b_imm;
    alumux::s_imm:		alumux2_out = idex_ireg_out.s_imm;
    alumux::j_imm:		alumux2_out = idex_ireg_out.j_imm;
    // alumux::rs2_out:	alumux2_out = idex_rs2reg_out;
    alumux::rs2_out:	alumux2_out = forwardmux2_out;
    default: `BAD_MUX_SEL;
  endcase

  unique case (idex_ctrlreg_out.cmpmux_sel)
    // cmpmux::rs2_out:	cmpmux_out = idex_rs2reg_out;
    cmpmux::rs2_out:	cmpmux_out = forwardmux2_out;
    cmpmux::i_imm: 	  cmpmux_out = idex_ireg_out.i_imm;
    default: `BAD_MUX_SEL;
  endcase
end

forwarding_unit forw_unit (
  .*
);

cmp cmp(
  .cmpop(idex_ctrlreg_out.cmpop),
  .rs1_out(forwardmux1_out),
  // .rs1_out(idex_rs1reg_out),
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
mem_forwarding_unit mem_forw_unit(
  .*
);

always_comb begin: MEM_MUXES
  unique case (mem_forwardmux2_sel)
    mem_forwardmux2::exmem_rs2:   mem_forwardmux2_out = exmem_rs2reg_out;
    mem_forwardmux2::regfilemux:  mem_forwardmux2_out = regfilemux_out;
    default: mem_forwardmux2_out = exmem_rs2reg_out;
  endcase
end

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
    // dcache_wdata = exmem_rs2reg_out << bit_shift;
    dcache_wdata = mem_forwardmux2_out << bit_shift;
    dcache_mbe = 4'b0001 << byte_shift;
  end
  else if (store_funct == sh) begin // sh
    // dcache_wdata = exmem_rs2reg_out << bit_shift;
    dcache_wdata = mem_forwardmux2_out << bit_shift;
    dcache_mbe = 4'b0011 << byte_shift;
  end
  else if (store_funct == sw) begin // sw
    // dcache_wdata = exmem_rs2reg_out;
    dcache_wdata = mem_forwardmux2_out;
    dcache_mbe = 4'b1111;
  end
  else begin
    dcache_wdata = 32'b0;
    dcache_mbe = 4'b0000;
  end
end

always_comb begin : LOAD_LOGIC // Load instructions
  logic [1:0] load_byte_shift;
  load_funct3_t load_funct;
  load_byte_shift = exmem_alureg_out[1:0];
  load_funct = load_funct3_t'(exmem_ireg_out.funct3);

  lw_out = dcache_rdata;

  unique case (exmem_alureg_out[1:0])
    2'b00: lh_out = {{16{dcache_rdata[15]}}, dcache_rdata[15:0]};
    2'b10: lh_out = {{16{dcache_rdata[31]}}, dcache_rdata[31:16]};
    default: lh_out = 32'b0;
  endcase

  unique case (exmem_alureg_out[1:0])
    2'b00: lb_out = {{24{dcache_rdata[ 7]}}, dcache_rdata[7:0]};
    2'b01: lb_out = {{24{dcache_rdata[15]}}, dcache_rdata[15:8]};
    2'b10: lb_out = {{24{dcache_rdata[23]}}, dcache_rdata[23:16]};
    2'b11: lb_out = {{24{dcache_rdata[31]}}, dcache_rdata[31:24]};
    default: lb_out = 32'b0;
  endcase

  unique case (exmem_alureg_out[1:0])
    2'b00: lbu_out = {24'b0, dcache_rdata[7:0]};
    2'b01: lbu_out = {24'b0, dcache_rdata[15:8]};
    2'b10: lbu_out = {24'b0, dcache_rdata[23:16]};
    2'b11: lbu_out = {24'b0, dcache_rdata[31:24]};
    default: lbu_out = 32'b0;
  endcase

  unique case (exmem_alureg_out[1:0])
    2'b00: lhu_out = {16'b0, dcache_rdata[15:0]};
    2'b10: lhu_out = {16'b0, dcache_rdata[31:16]};
    default: lhu_out = 32'b0;
  endcase
  
  
  load_dcache_mbe = (exmem_ireg_out.opcode == op_load) ? 4'b1111 : 4'b0000;

  if (load_funct == lb) begin
    load_logic_out = lb_out;
    // load_dcache_mbe = 4'b0001 << load_byte_shift;
  end else if (load_funct == lbu) begin
    load_logic_out = lbu_out;
    // load_dcache_mbe = 4'b0001 << load_byte_shift;
  end else if (load_funct == lh) begin
    load_logic_out = lh_out;
    // load_dcache_mbe = 4'b0011 << load_byte_shift;
  end else if (load_funct == lhu) begin
    load_logic_out = lhu_out;
    // load_dcache_mbe = 4'b0011 << load_byte_shift;
  end else if (load_funct == lw) begin
    load_logic_out = lw_out;
    // load_dcache_mbe = 4'b1111;
  end else begin
    load_logic_out = lw_out;
    // load_dcache_mbe = 4'b0000;
  end

end



// ********** WB Stage **********
always_comb begin : WB_MUXES
  unique case (memwb_ctrlreg_out.regfilemux_sel)
    regfilemux::alu_out: regfilemux_out = memwb_alureg_out;
    regfilemux::u_imm: regfilemux_out = memwb_ireg_out.u_imm;
    regfilemux::pc_plus4: regfilemux_out = memwb_pcreg_out + 4;
    regfilemux::br_en: regfilemux_out = {31'd0, memwb_brreg_out};
    regfilemux::mdr: regfilemux_out = memwb_memdatareg_out;
    default: `BAD_MUX_SEL;
  endcase
end

// ******************** Stages END ********************





// ******************** Branch Prediction BEGIN ********************

btb #(.BTB_INDEX(5), .BTB_IDX_START(6))
btb (
  .*,
  .btb_load(
    (idex_ireg_out.opcode == op_br || idex_ireg_out.opcode == op_jal) //|| idex_ireg_out.opcode == op_jalr) 
    & ~dcache_stall & ~icache_stall
  ),
  .br_en(br_en),
  .pc_address_if(pcreg_out),
  .pc_address_ex(idex_pcreg_out),
  .br_address(alu_out),
  .hit(btb_hit),
  .predicted_pc(btb_pc_out)
);

tournament_predictor #(.pc_idx_start(6), .idx_width(4))
tournament (
  .*,
  .stall(dcache_stall | icache_stall),
  .read_pc(pcreg_out),
  .write_pc(idex_pcreg_out),
  .pred_ld(
    (idex_ireg_out.opcode == op_br || idex_ireg_out.opcode == op_jal || idex_ireg_out.opcode == op_jalr) 
    & ~dcache_stall & ~icache_stall
  ),
  .cpu_br_en(br_en),
  .read_opcode(icache_rdata[6:0]),
  .pred_br(pred_br)
);

// ******************** Branch Prediction END ********************





// ******************** Pipeline Registers BEGIN ********************
// ********** IF/ID Pipeline Registers **********
// $bits returns size of struct in bits
register #(.width($bits(instr_struct)))
ifid_ireg (
  .*,
  .rst(pipe_ctrl.ifid_rst),
  .load(pipe_ctrl.ifid_ld),
  .in(instr_decode(icache_rdata)),
  .out(ifid_ireg_out)
);

register #(.width(32))
ifid_pcreg (
  .*,
  .rst(pipe_ctrl.ifid_rst),
  .load(pipe_ctrl.ifid_ld),
  .in(pcreg_out),
  .out(ifid_pcreg_out)
);

register #(.width(1))
ifid_btb_take (
  .*,
  .rst(pipe_ctrl.ifid_rst),
  .load(pipe_ctrl.ifid_ld),
  .in(btb_hit & pred_br),
  .out(ifid_btb_take_out)
);


// ********** ID/EX Pipeline Registers **********
register #(.width($bits(instr_struct)))
idex_ireg (
  .*,
  .rst(pipe_ctrl.idex_rst),
  .load(pipe_ctrl.idex_ld),
  .in(ifid_ireg_out),
  .out(idex_ireg_out)
);

register #(.width(32))
idex_pcreg (
  .*,
  .rst(pipe_ctrl.idex_rst),
  .load(pipe_ctrl.idex_ld),
  .in(ifid_pcreg_out),
  .out(idex_pcreg_out)
);

register #(.width(32))
idex_rs1reg (
  .*,
  .rst(pipe_ctrl.idex_rst),
  .load(pipe_ctrl.idex_ld),
  .in(regfile_rs1_out),
  .out(idex_rs1reg_out)
);

register #(.width(32))
idex_rs2reg (
  .*,
  .rst(pipe_ctrl.idex_rst),
  .load(pipe_ctrl.idex_ld),
  .in(regfile_rs2_out),
  .out(idex_rs2reg_out)
);

register #(.width($bits(ctrl_word_struct)))
idex_ctrlreg (
  .*,
  .rst(pipe_ctrl.idex_rst),
  .load(pipe_ctrl.idex_ld),
  .in(ctrl_word_out),
  .out(idex_ctrlreg_out)
);

register #(.width(1))
idex_btb_take (
  .*,
  .rst(pipe_ctrl.idex_rst),
  .load(pipe_ctrl.idex_ld),
  .in(ifid_btb_take_out),
  .out(idex_btb_take_out)
);

// ********** EX/MEM Pipeline Registers **********
register #(.width($bits(instr_struct)))
exmem_ireg (
  .*,
  .rst(pipe_ctrl.exmem_rst),
  .load(pipe_ctrl.exmem_ld),
  .in(idex_ireg_out),
  .out(exmem_ireg_out)
);

register #(.width(32))
exmem_pcreg (
  .*,
  .rst(pipe_ctrl.exmem_rst),
  .load(pipe_ctrl.exmem_ld),
  .in(idex_pcreg_out),
  .out(exmem_pcreg_out)
);

register #(.width(32))
exmem_rs2reg (
  .*,
  .rst(pipe_ctrl.exmem_rst),
  .load(pipe_ctrl.exmem_ld),
  // .in(idex_rs2reg_out),
  .in(forwardmux2_out),
  .out(exmem_rs2reg_out)
);

register #(.width($bits(ctrl_word_struct)))
exmem_ctrlreg (
  .*,
  .rst(pipe_ctrl.exmem_rst),
  .load(pipe_ctrl.exmem_ld),
  .in(idex_ctrlreg_out),
  .out(exmem_ctrlreg_out)
);

register #(.width(32))
exmem_alureg (
  .*,
  .rst(pipe_ctrl.exmem_rst),
  .load(pipe_ctrl.exmem_ld),
  .in(alu_out),
  .out(exmem_alureg_out)
);

register #(.width(1))
exmem_brreg (
  .*,
  .rst(pipe_ctrl.exmem_rst),
  .load(pipe_ctrl.exmem_ld),
  .in(br_en_cmp),   // Not jump logic
  .out(exmem_brreg_out)
);


// ********** MEM/WB Pipeline Registers **********
register #(.width($bits(instr_struct)))
memwb_ireg (
  .*,
  .rst(pipe_ctrl.memwb_rst),
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_ireg_out),
  .out(memwb_ireg_out)
);

register #(.width(32))
memwb_pcreg (
  .*,
  .rst(pipe_ctrl.memwb_rst),
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_pcreg_out),
  .out(memwb_pcreg_out)
);

register #(.width($bits(ctrl_word_struct)))
memwb_ctrlreg (
  .*,
  .rst(pipe_ctrl.memwb_rst),
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_ctrlreg_out),
  .out(memwb_ctrlreg_out)
);

register #(.width(32))
memwb_alureg (
  .*,
  .rst(pipe_ctrl.memwb_rst),
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_alureg_out),
  .out(memwb_alureg_out)
);

register #(.width(1))
memwb_brreg (
  .*,
  .rst(pipe_ctrl.memwb_rst),
  .load(pipe_ctrl.memwb_ld),
  .in(exmem_brreg_out),
  .out(memwb_brreg_out)
);

register #(.width(32))
memwb_memrdata (
  .*,
  .rst(pipe_ctrl.memwb_rst),
  .load(pipe_ctrl.memwb_ld),
  .in(load_logic_out),
  .out(memwb_memdatareg_out)
);

// ******************** Pipeline Registers END ********************


endmodule : datapath