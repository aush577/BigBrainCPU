import rv32i_types::*;
import types::*;
import alumux::*;

module ctrl_rom(
  input rv32i_opcode opcode,
  input logic [2:0] funct3,
  input logic [6:0] funct7,
  output ctrl_word_struct ctrl_word
);

function void set_defaults();
  ctrl_word.regfile_ld = 1'b0;
  ctrl_word.alumux1_sel = alumux::rs1_out;
  ctrl_word.alumux2_sel = alumux::i_imm;
  ctrl_word.cmpmux_sel = cmpmux::rs2_out;
  ctrl_word.regfilemux_sel = regfilemux::alu_out;
  ctrl_word.dcache_read = 1'b0;
  ctrl_word.dcache_write = 1'b0;
  ctrl_word.aluop = alu_add;
  ctrl_word.cmpop = beq;
endfunction

always_comb begin
  set_defaults();
  unique case (opcode)
    op_lui: begin
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.regfilemux_sel = regfilemux::u_imm;
    end
    
    op_auipc: begin
      ctrl_word.alumux1_sel = alumux::pc_out;
      ctrl_word.alumux2_sel = alumux::u_imm;
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.aluop = alu_add;
    end
    
    op_jal: begin
      ctrl_word.regfilemux_sel = regfilemux::pc_plus4;
      ctrl_word.aluop = rv32i_types::alu_add;
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.alumux1_sel = alumux::pc_out;
      ctrl_word.alumux2_sel = alumux::j_imm;
    end
    
    op_jalr: begin
      ctrl_word.regfilemux_sel = regfilemux::pc_plus4;
      ctrl_word.aluop = rv32i_types::alu_add;
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.alumux1_sel = alumux::rs1_out;
      ctrl_word.alumux2_sel = alumux::i_imm;
    end
    
    op_br: begin
      ctrl_word.alumux1_sel = alumux::pc_out;
      ctrl_word.alumux2_sel = alumux::b_imm;
      ctrl_word.aluop = alu_add;
      ctrl_word.cmpop = branch_funct3_t'(funct3);
    end
    
    op_load: 	begin
      ctrl_word.regfilemux_sel = regfilemux::lw;  //assigned to memwb_memdatareg_out
      ctrl_word.aluop = alu_add;
      ctrl_word.regfile_ld = 1'b1;
    end
    
    op_store:	begin
      
    end
    
    op_imm: 	begin
      unique case (funct3)
			  default: ;
      endcase    
    end
    
    op_reg: 	begin
      unique case (funct3)
			  default: ;
      endcase  
    end
    
    op_csr: 	begin
      
    end
  
    default: begin
     set_defaults();
		end
  endcase
end
endmodule : ctrl_rom