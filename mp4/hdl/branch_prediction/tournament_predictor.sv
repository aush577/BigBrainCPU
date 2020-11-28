module tournament_predictor 
#(parameter pc_idx_start=6, parameter pc_idx_width=4, parameter bhr_width=4)
(
  input clk,
  input rst,
  input pc,
  input pred_ld,
  input br_en,
  
  output pred_br
);

logic global_pred_br;
logic local_pred_br;

global_branch_predictor #(.pc_idx_start(pc_idx_start), .pc_idx_width(pc_idx_width), .bhr_width(bhr_width)) 
global (
  .clk(clk),
  .rst(rst),
  .glob_pred_ld(pred_ld),
  .cpu_br_en(br_en),
  .pc(pc),
  .pred_br_out(global_pred_br)
);

pattern_history_table #(.index(pc_idx_width)) 
local (
  .clk(clk),
  .rst(rst),
  .pht_index(pc[pc_idx_start : pc_idx_start-pc_idx_width-1]),
  .cpu_br_en(br_en),
  .pht_ld(pred_ld),
  .predicted_branch(local_pred_br)
);

endmodule : tournament_predictor
