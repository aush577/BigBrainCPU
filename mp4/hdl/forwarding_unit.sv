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

// always_comb begin
//   // rs1
//   if (exmem_ctrlreg_out.regfile_ld 
//       && exmem_ireg_out.rd != 0 
//       && exmem_ireg_out.rd == idex_ireg_out.rs1
//   ) begin
//     forwardmux1_sel = forwardmux1::exmem_alureg_out;
//   end
//   else 
//   if (memwb_ctrlreg_out.regfile_ld 
//       && memwb_ireg_out.rd != 0
//       && !(exmem_ctrlreg_out.regfile_ld
//       && exmem_ireg_out.rd != 0
//       && exmem_ireg_out.rd != idex_ireg_out.rs1)
//       && memwb_ireg_out.rd == idex_ireg_out.rs1
//   ) begin
//     forwardmux1_sel = forwardmux1::regfilemux_out;
//   end
//   else begin
//     forwardmux1_sel = forwardmux1::idex_rs1reg_out;
//   end

//   // rs2 
//   if (exmem_ctrlreg_out.regfile_ld 
//       && exmem_ireg_out.rd != 0
//       && exmem_ireg_out.rd == idex_ireg_out.rs2
//   ) begin
//     forwardmux2_sel = forwardmux2::exmem_alureg_out;
//   end
//   else 
//   if (memwb_ctrlreg_out.regfile_ld 
//       && memwb_ireg_out.rd != 0
//       && !(exmem_ctrlreg_out.regfile_ld
//       && exmem_ireg_out.rd != 0
//       && exmem_ireg_out.rd != idex_ireg_out.rs2)
//       && memwb_ireg_out.rd == idex_ireg_out.rs2
//   ) begin
//     forwardmux2_sel = forwardmux2::regfilemux_out;
//   end
//   else begin
//     forwardmux2_sel = forwardmux2::idex_rs2reg_out;
//   end
// end

always_comb begin
  forwardmux1_sel = forwardmux1::idex_rs1reg_out;
  forwardmux2_sel = forwardmux2::idex_rs2reg_out;
end

endmodule : forwarding_unit