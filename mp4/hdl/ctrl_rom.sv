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
    end
    
    op_jal: begin
      ctrl_word.regfilemux_sel = regfilemux::pc_plus4;
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.alumux1_sel = alumux::pc_out;
      ctrl_word.alumux2_sel = alumux::j_imm;
    end
    
    op_jalr: begin
      ctrl_word.regfilemux_sel = regfilemux::pc_plus4;
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.alumux1_sel = alumux::rs1_out;
      ctrl_word.alumux2_sel = alumux::i_imm;
    end
    
    op_br: begin
      ctrl_word.alumux1_sel = alumux::pc_out;
      ctrl_word.alumux2_sel = alumux::b_imm;
      ctrl_word.cmpop = branch_funct3_t'(funct3);
    end
    
    op_load: 	begin
      unique case (funct3)
        lb: ctrl_word.regfilemux_sel = regfilemux::lb;
        lh: ctrl_word.regfilemux_sel = regfilemux::lh;
        lw: ctrl_word.regfilemux_sel = regfilemux::lw;  // memwb_memdatareg_out
        lbu: ctrl_word.regfilemux_sel = regfilemux::lbu;
        lhu: ctrl_word.regfilemux_sel = regfilemux::lhu;
        default: ctrl_word.regfilemux_sel = regfilemux::lw;  // memwb_memdatareg_out
      endcase
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.dcache_read = 1'b1;
    end
    
    op_store:	begin
      ctrl_word.dcache_write = 1'b1;
    end
    
    op_imm: 	begin
      ctrl_word.aluop = alu_ops'(funct3);
      ctrl_word.regfile_ld = 1'b1;
      unique case (funct3)
        slt: begin
					ctrl_word.cmpop = blt;
					ctrl_word.regfilemux_sel = regfilemux::br_en;
					ctrl_word.cmpmux_sel = cmpmux::i_imm;
				end

				sltu: begin
					ctrl_word.cmpop = bltu;
					ctrl_word.regfilemux_sel = regfilemux::br_en;
					ctrl_word.cmpmux_sel = cmpmux::i_imm;		
				end

        sr: begin
          ctrl_word.aluop = (funct7[5] == 1'b1) ? alu_sra : alu_srl;
				end
			  default: ;
      endcase    
    end
    
    op_reg: 	begin
      ctrl_word.aluop = alu_ops'(funct3);
      ctrl_word.regfile_ld = 1'b1;
      ctrl_word.alumux2_sel = alumux::rs2_out;
      unique case (funct3)
        add: begin
          ctrl_word.aluop = (funct7[5] == 1'b1) ? alu_sub : alu_add;
				end
        
        slt: begin
					ctrl_word.cmpop = blt;
					ctrl_word.regfilemux_sel = regfilemux::br_en;
					ctrl_word.cmpmux_sel = cmpmux::i_imm;
				end
				
				sltu: begin
					ctrl_word.cmpop = bltu;
					ctrl_word.regfilemux_sel = regfilemux::br_en;
					ctrl_word.cmpmux_sel = cmpmux::i_imm;		
				end
       
        sr: begin
          ctrl_word.aluop = (funct7[5] == 1'b1) ? alu_sra : alu_srl;
				end
			  default: ;
      endcase     
    end
    
    // op_csr: 	begin // Don't need to implement
    // end
  
    default: begin
     set_defaults();
		end
  endcase
end
endmodule : ctrl_rom