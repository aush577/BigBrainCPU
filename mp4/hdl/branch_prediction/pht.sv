module pattern_history_table 
#(parameter int index = 4)
(
  input clk,
  input rst,
  input [index-1:0] pht_rindex,
  input [index-1:0] pht_windex,
  input cpu_br_en,
  input [6:0] read_opcode,
  input pht_ld,
  output predicted_br
);

typedef enum bit [1:0]
{
  SNT = 2'b00,
	WNT = 2'b01,
  WT = 2'b10,
  ST = 2'b11
} pht_br_state;

pht_br_state pattern_history_table [(2**index) - 1 : 0];

// TODO write read pass through
// op_jal   = 7'b1101111
// op_jalr  = 7'b1100111
// op_br    = 7'b1100011

assign predicted_br = ((read_opcode == 7'b1100011) || (read_opcode == 7'b1101111) || (read_opcode == 7'b1100111)) ?
                      pattern_history_table[pht_rindex][1]
                      : 1'b0;

pht_br_state write_state;
assign write_state = pattern_history_table[pht_windex];

always_ff @(posedge clk) begin
  if (rst) begin
    for (int i=0; i < (2**index); ++i) begin
      pattern_history_table[i] <= WNT;
    end
  end else begin
    if (pht_ld) begin
      if (cpu_br_en & (pattern_history_table[pht_windex] < ST)) begin
        pattern_history_table[pht_windex] <= pht_br_state'(pattern_history_table[pht_windex] + 1);
      end
      else if (~cpu_br_en & (pattern_history_table[pht_windex] > SNT)) begin
        pattern_history_table[pht_windex] <= pht_br_state'(pattern_history_table[pht_windex] - 1);
      end
    end
  end

end

endmodule: pattern_history_table
