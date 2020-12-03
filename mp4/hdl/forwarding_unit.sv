import rv32i_types::*;
import types::*;

module forwarding_unit (
  input instr_struct idex_ireg_out,
  input instr_struct exmem_ireg_out,
  input instr_struct memwb_ireg_out,
  input ctrl_word_struct exmem_ctrlreg_out,
  input ctrl_word_struct memwb_ctrlreg_out,
  output forwardmux1::forwardmux1_sel_t forwardmux1_sel,
  output forwardmux2::forwardmux2_sel_t forwardmux2_sel
);

always_comb begin
  // rs1
  if (exmem_ctrlreg_out.regfile_ld 
      && exmem_ireg_out.rd != 0 
      && exmem_ireg_out.rd == idex_ireg_out.rs1
  ) begin
    if (exmem_ireg_out.opcode == op_load) begin   // MEM -> EX forwarding for loads
      forwardmux1_sel = forwardmux1::mem_rdata;
    end else if (exmem_ireg_out.opcode == op_lui) begin
      forwardmux1_sel = forwardmux1::mem_uimm;
    end else begin
      forwardmux1_sel = forwardmux1::exmem_alu;
    end
  end
  else 
  if (memwb_ctrlreg_out.regfile_ld 
      && memwb_ireg_out.rd != 0
      && !(exmem_ctrlreg_out.regfile_ld
      && exmem_ireg_out.rd != 0
      && exmem_ireg_out.rd == idex_ireg_out.rs1)
      && memwb_ireg_out.rd == idex_ireg_out.rs1
  ) begin
    forwardmux1_sel = forwardmux1::regfilemux;
  end
  else begin
    forwardmux1_sel = forwardmux1::idex_rs1;
  end

  // rs2 
  if (exmem_ctrlreg_out.regfile_ld 
      && exmem_ireg_out.rd != 0
      && exmem_ireg_out.rd == idex_ireg_out.rs2
  ) begin
    if (exmem_ireg_out.opcode == op_load) begin   // MEM -> EX forwarding for loads
      forwardmux2_sel = forwardmux2::mem_rdata;
    end else if (exmem_ireg_out.opcode == op_lui) begin
      forwardmux2_sel = forwardmux2::mem_uimm;
    end else begin
      forwardmux2_sel = forwardmux2::exmem_alu;
    end
  end
  else 
  if (memwb_ctrlreg_out.regfile_ld 
      && memwb_ireg_out.rd != 0
      && !(exmem_ctrlreg_out.regfile_ld
      && exmem_ireg_out.rd != 0
      && exmem_ireg_out.rd == idex_ireg_out.rs2)
      && memwb_ireg_out.rd == idex_ireg_out.rs2
  ) begin
    forwardmux2_sel = forwardmux2::regfilemux;
  end
  else begin
    forwardmux2_sel = forwardmux2::idex_rs2;
  end
end

// (No forwarding)
// always_comb begin
//   forwardmux1_sel = forwardmux1::idex_rs1;
//   forwardmux2_sel = forwardmux2::idex_rs2;
// end

endmodule : forwarding_unit



module mem_forwarding_unit (
  input instr_struct exmem_ireg_out,
  input instr_struct memwb_ireg_out,
  input ctrl_word_struct memwb_ctrlreg_out,
  output mem_forwardmux2::mem_forwardmux2_sel_t mem_forwardmux2_sel
);

always_comb begin
  if (exmem_ireg_out.opcode == op_store 
      && memwb_ctrlreg_out.regfile_ld == 1'b1
      && memwb_ireg_out.rd != 0
      && memwb_ireg_out.rd == exmem_ireg_out.rs2
  ) begin
    mem_forwardmux2_sel = mem_forwardmux2::regfilemux;
  end else begin
    mem_forwardmux2_sel = mem_forwardmux2::exmem_rs2;
  end
end

// (No forwarding)
// always_comb begin
//   mem_forwardmux2_sel = mem_forwardmux2::exmem_rs2;
// end

endmodule : mem_forwarding_unit
