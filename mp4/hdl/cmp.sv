import rv32i_types::*;

module cmp (
	input branch_funct3_t cmpop,
	input rv32i_word rs1_out,
	input rv32i_word i_imm,
	output logic br_en
);

always_comb begin
	unique case (cmpop)
		beq:  br_en = (rs1_out == i_imm);
		bne:  br_en = (rs1_out != i_imm);
		blt:  br_en = ($signed(rs1_out) < $signed(i_imm));
		bge:  br_en = ($signed(rs1_out) >= $signed(i_imm));
		bltu: br_en = (rs1_out < i_imm);
		bgeu: br_en = (rs1_out >= i_imm);
	endcase
end

endmodule : cmp
