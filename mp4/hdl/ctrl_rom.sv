import rv32i_types::*;

module ctrl_rom(
  input rv32i_opcode opcode,
  input logic [2:0] funct3,
  input logic [6:0] funct7,
  output [31:0] ctrl_word
);

//function set_defaults();
//  return ;
//endfunction

always_comb begin
  unique case (opcode)
    op_lui: begin
    
    end
    
    op_auipc: begin
      
    end
    
    op_jal: 	begin
      
    end
    
    op_jalr: 	begin
      
    end
    
    op_br: 		begin
      
    end
    
    op_load: 	begin
      
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
//      set_defaults();
		end
  endcase
end
endmodule : ctrl_rom