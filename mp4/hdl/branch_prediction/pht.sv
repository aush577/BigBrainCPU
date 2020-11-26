module pattern_history_table 
#(parameter int index = 4)
(
  input clk,
  input rst,
  input [index-1:0] pht_index,
  input cpu_br_en,
  input pht_ld,
  output predicted_branch
);

typedef enum bit [1:0]
{
  SNT = 2'b00,
	WNT = 2'b01,
  WT = 2'b10,
  ST = 2'b11
} pht_br_state;

pht_br_state pattern_history_table [(2**index) - 1 : 0];

assign predicted_branch = pattern_history_table[pht_index][1];

always_ff @(posedge clk) begin  
  if (rst) begin
    for (int i=0; i < (2**index); ++i) begin
      pattern_history_table[i] = WNT;
    end

  end else begin
    if (pht_ld) begin
      if (cpu_br_en & (pattern_history_table[pht_index] < ST)) begin
        pattern_history_table[pht_index] <= pattern_history_table[pht_index] + 1;
      end
      else if (~cpu_br_en & (pattern_history_table[pht_index] > SNT)) begin
        pattern_history_table[pht_index] <= pattern_history_table[pht_index] - 1;
      end
    end
  end

end

endmodule: pattern_history_table
