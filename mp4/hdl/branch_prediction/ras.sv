import rv32i_types::*;
import types::*;

// Return Address Stack
module ras
#(parameter RAS_INDEX = 3)
(
  input clk,
  input rst,
  input stall,
  input instr_struct ex_instr,
  input [31:0] ex_pcp4,
  output logic [31:0] target_addr_out,
  output logic empty
);

logic [6:0] opcode;
logic [4:0] rd;
logic [4:0] rs1;
logic link_rd;
logic link_rs1;

assign opcode = ex_instr.opcode;
assign rd = ex_instr.rd;
assign rs1 = ex_instr.rs1;
assign link_rd = (rd == 5'd1 || rd == 5'd5);
assign link_rs1 = (rs1 == 5'd1 || rs1 == 5'd5);

logic push;
logic pop;

always_comb begin
  push = 0;
  pop = 0;
  if ((opcode == op_jalr || opcode == op_jal) && ~stall) begin
    unique case ({link_rd, link_rs1})
      2'b00: begin end

      2'b01: pop = 1'b1;

      2'b10: push = 1'b1;        

      2'b11: begin
        if (rd == rs1) begin
          push = 1'b1;
        end
        else begin
          push = 1'b1;
          pop = 1'b1;
        end
      end
      
      default: begin 
        push = 0;
        pop = 0;
      end
    endcase
  end
end

stack stack (
  .*,
  .addr_in(ex_pcp4),
  .addr_out(target_addr_out)
);


endmodule : ras
